
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/cart_top_app_bar.dart';
import 'dart:convert';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/api_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../utils/constants/product_price.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../scheme/Screens/ProductOrderFailSummaryPage.dart';
import '../../../scheme/Screens/ProductOrderSuccessSummaryPage.dart';
import '../../../scheme/Widgets/page_exp_controller.dart';
import '../../apiService/capturePaymentAPI.dart';
import '../../apiService/paymentOrderAPI.dart';
import '../../controller/post_transaction_Api_calling.dart';
import '../../models/capture_payment_success.dart';
import '../../models/order_api_success.dart';
import '../../models/product_transaction_DTO_list.dart';
import '../../models/razorpay_failure_response.dart';
import '../../models/transaction_DTO.dart';
import '../../models/transaction_request_wrapper_DTO.dart';

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({super.key});

  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  final loginController = Get.find<LoginController>();
  Map<String, dynamic>? cartData;
  bool isLoading = true;

  final Razorpay _razorpay = Razorpay();
  final RazorpayOrderAPI razorpayOrderAPI = RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);
  final RazorpayCapturePayment capturePayment = RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;

  @override
  void initState() {
    super.initState();
    fetchCartData();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchCartData() async {
    final userId = loginController.userData['userId'];
    final url = Uri.parse('http://103.108.12.222:11004/kalpco/carts/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          cartData = json.decode(response.body)['payload'];
          isLoading = false;
        });
      } else {
        print('Failed to load cart data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateCartItemQuantity(String userId, String productId, int newQuantity, double unitPrice) async {
    final url = Uri.parse('http://103.108.12.222:11004/kalpco/carts/$userId');
    final cartId = cartData!['cartId'];
    final newPrice = unitPrice * newQuantity; // Calculate the new total price
    final items = cartData!['items'].map((item) {
      if (item['productId'] == productId) {
        return {
          'productId': item['productId'],
          'image': item['image'],
          'description': item['description'],
          'price': newPrice, // Update the price
          'quantity': newQuantity,
        };
      } else {
        return item;
      }
    }).toList();

    final updatedCart = {
      'cartId': cartId,
      'items': items,
    };

    print('Updating cart: $updatedCart'); // Debugging statement

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCart),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cart updated successfully');
        setState(() {
          cartData!['items'] = items;
        });
      } else {
        print('Failed to update cart: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteCartItem(String userId, String productId) async {
    final url = Uri.parse('http://103.108.12.222:11004/kalpco/carts/$userId');
    final cartId = cartData!['cartId'];
    final items = cartData!['items'].where((item) => item['productId'] != productId).toList();

    final updatedCart = {
      'cartId': cartId,
      'items': items,
    };

    print('Deleting item from cart: $updatedCart'); // Debugging statement

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCart),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Item deleted successfully');
        setState(() {
          cartData!['items'] = items;
        });
      } else {
        print('Failed to delete item: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateTotalPrice() {
    if (cartData == null) return 0.0;
    return cartData!['items'].fold(0.0, (sum, item) => sum + item['price']);
  }

  Future<void> _handleCheckout() async {
    // Create Order and then open checkout
    await _createOrder(context);
  }

  Future<void> _createOrder(BuildContext context) async {
    try {
      final amountInPaise = (calculateTotalPrice() * 100).toInt();
      final orderResponse = await razorpayOrderAPI.createOrder(amountInPaise, 'INR', 'order_receipt#1');
      if (orderResponse is RazorpaySuccessResponseDTO) {
        print('Order created successfully: $orderResponse');
        razorpaySuccessResponseDTO = orderResponse;
        _openCheckout(orderResponse);
      } else if (orderResponse is RazorpayFailureResponse) {
        print('Failed to create order: ${orderResponse.error.code}');
        final loginController = Get.find<LoginController>();
        int userId = loginController.userData['userId'];


        final failedOrderDetails = TransactionRequestResponseWrapperDTO(
          productTransactionDTOList: cartData!['items'].map<ProductTransactionDTO>((item) {
            return ProductTransactionDTO(
              productId: item['productId'],
              productPrice: item['price']?.toDouble(),
              productQuantity: item['quantity']?.toInt(),
              productWeight: 0.0,
              gstCharge: 0.0,
              makingCharges: 0.0,
              payedFromWallet: false,
              createDate: DateTime.now(),
              userId: userId,
              productPic: item['image'].toString(),
              productName: item['description'].toString(),
              totalAmount: item['price']?.toDouble(),
            );
          }).toList(),
          transactionDTO: TransactionDTO(
            userId: userId,
            transactionStatus: orderResponse.error.description +"_"+orderResponse.error.reason+"_"+orderResponse.error.field+":"+orderResponse.error.code,
            transactionMessage: 'Failed to create order',
            createDate: DateTime.now(),
          ),
        ).toJson();

        await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
      }
    } catch (e) {
      print('Failed to place order: $e');
    }
  }

  void _openCheckout(RazorpaySuccessResponseDTO order) async {
    final loginController = Get.find<LoginController>();
    final email = loginController.userData['email'];
    final mobileNumber = loginController.userData['mobileNo'];
    var options = {
      'key': 'rzp_live_5fpmFBZvv8QIEr',
      'amount': order.amount.toString(),
      'name': 'Kalpco',
      "timeout": "180",
      "currency": "INR",
      'prefill': {'contact': mobileNumber, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Success -> : ${response.paymentId}');
    bool isCaptured = await _capturePaymentRazorPay(
      paymentId: response.paymentId!,
      responseDTO: razorpaySuccessResponseDTO,
    );

    if (isCaptured) {
      _postTransactionDetails(
        responseDTO: razorpaySuccessResponseDTO,
        paymentId: response.paymentId!,
        successResponseCapturePayment: capturePaymentRazorPayResponse,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductOrderSuccessSummaryPage(
            paymentId: response.paymentId!,
            order: razorpaySuccessResponseDTO, investment: null,
          ),
        ),
      );
    } else {
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];

      final failedCapturePaymentDetails = TransactionRequestResponseWrapperDTO(
        productTransactionDTOList: cartData!['items'].map<ProductTransactionDTO>((item) {
          return ProductTransactionDTO(
            productId: item['productId'],
            productPrice: item['price']?.toDouble(),
            productQuantity: item['quantity']?.toInt(),
            payedFromWallet: false,
            createDate: DateTime.now(),
            userId: userId,
            productPic: item['image'].toString(),
            productName: item['description'].toString(),
            totalAmount: item['price']?.toDouble(),
          );
        }).toList(),
        transactionDTO: TransactionDTO(
          userId: userId,
          transactionStatus: razorpaySuccessResponseDTO.status +
              "_" +
              razorpayFailureResponse.error.code +
              "_" +
              razorpayFailureResponse.error.reason +
              "_" +
              razorpayFailureResponse.error.field +
              ":" +
              razorpayFailureResponse.error.description,
          transactionMessage: 'Payment created but not captured',
          createDate: DateTime.now(),
        ),
      ).toJson();
      await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment Error: ${response.code} - ${response.message}');

    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];

    final failedCapturePaymentDetails = TransactionRequestResponseWrapperDTO(
      productTransactionDTOList: cartData!['items'].map<ProductTransactionDTO>((item) {
        return ProductTransactionDTO(
          productId: item['productId'],
          productPrice: item['price']?.toDouble(),
          productQuantity: item['quantity']?.toInt(),
          payedFromWallet: false,
          createDate: DateTime.now(),
          userId: userId,
          productPic: item['image'].toString(),
          productName: item['description'].toString(),
          totalAmount: item['price']?.toDouble(),
        );
      }).toList(),
      transactionDTO: TransactionDTO(
        userId: userId,
        transactionStatus:razorpaySuccessResponseDTO.status + "_" + response.message! + "_" + response.code.toString(),
        transactionMessage: response.message,
        createDate: DateTime.now(),
      ),
    ).toJson();

    await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductOrderFailSummaryPage(
          message: response.message!,
          order: razorpaySuccessResponseDTO,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  Future<bool> _capturePaymentRazorPay({required String paymentId, required RazorpaySuccessResponseDTO responseDTO}) async {
    bool isSaved = false;
    try {
      final capturePaymentResponse = await capturePayment.capturePayment(responseDTO.amount, responseDTO.currency, paymentId);
      if (capturePaymentResponse is CapturePaymentRazorPay) {
        print('Payment captured successfully: ${capturePaymentResponse}');
        capturePaymentRazorPayResponse = capturePaymentResponse;
        isSaved = true;
      } else if (capturePaymentResponse is RazorpayFailureResponse) {
        print('Failed to capture payment: ${capturePaymentResponse.error.code}');
        razorpayFailureResponse = capturePaymentResponse;
        isSaved = false;
      }
    } catch (e) {
      print('Failed to capture order: $e');
      isSaved = false;
    }
    return isSaved;
  }

  void _postTransactionDetails({
    required RazorpaySuccessResponseDTO responseDTO,
    required String paymentId,
    required CapturePaymentRazorPay successResponseCapturePayment,
  }) async {
    final loginController = Get.find<LoginController>();
    int activeUserId = loginController.userData['userId'];

    try {
      final transactionDetails = TransactionRequestResponseWrapperDTO(
        productTransactionDTOList: cartData!['items'].map<ProductTransactionDTO>((item) {
          return ProductTransactionDTO(
            productId: item['productId'],
            productPrice: item['price']?.toDouble(),
            productQuantity: item['quantity']?.toInt(),
            productWeight: 0.0,
            gstCharge: 0.0,
            makingCharges: 0.0,
            payedFromWallet: false,
            createDate: DateTime.now(),
            userId: activeUserId,
            productPic: item['image'].toString(),
            productName: item['description'].toString(),
            totalAmount: item['price']?.toDouble(),
          );
        }).toList(),
        transactionDTO: TransactionDTO(
          paymentGatewayTransactionId: paymentId,
          userId: activeUserId,
          transactionStatus: responseDTO.status + "_" + successResponseCapturePayment.status,
          transactionMessage: 'Cart Payment Completed Successfully',
          transactionOrderId: successResponseCapturePayment.orderId,
          createDate: DateTime.now(),
        ),
      ).toJson();

      print('Transaction Details: $transactionDetails');

      final response = await TranactionOrderAPI.postTransactionDetails(transactionDetails);

      if (response.statusCode == 201) {
        print('Payment details posted successfully');
        print('Response Body: ${response.body}');
      } else {
        print('Failed to post payment details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error posting payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String deliverable = loginController.userData['isDeliverable'];
    return CartTopAppBar(
      body: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(U_Sizes.defaultSpace),
          child: ElevatedButton(
            //onPressed: _handleCheckout,
            onPressed: () {
              if (deliverable == 'Y') {
                _createOrder(context);
              } else {
                _showAlertDialog();
              }
            },
            child: Text('Checkout \₹${calculateTotalPrice()}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: U_Colors.chatprimaryColor,
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: EdgeInsets.all(U_Sizes.defaultSpace),
          child: cartData == null || cartData!['items'].isEmpty
              ? Center(child: Text('No items in the cart'))
              : ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: U_Sizes.spaceBwtSections),
            itemCount: cartData!['items'].length,
            itemBuilder: (_, index) {
              final item = cartData!['items'][index];
              return Dismissible(
                key: Key(item['productId']),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteCartItem(loginController.userData['userId'].toString(), item['productId']);
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Column(
                  children: [
                    ProductCartItems(
                      image: "${ApiConstants.baseUrl}${item['image']}",
                      description: item['description'],
                    ),
                    SizedBox(height: U_Sizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductQuantityWithButton(
                          quantity: item['quantity'],
                          onIncrement: () {
                            final newQuantity = item['quantity'] + 1;
                            updateCartItemQuantity(
                              loginController.userData['userId'].toString(),
                              item['productId'],
                              newQuantity,
                              item['price'] / item['quantity'], // Pass unit price
                            );
                          },
                          onDecrement: () {
                            if (item['quantity'] > 1) {
                              final newQuantity = item['quantity'] - 1;
                              updateCartItemQuantity(
                                loginController.userData['userId'].toString(),
                                item['productId'],
                                newQuantity,
                                item['price'] / item['quantity'], // Pass unit price
                              );
                            }
                          },
                        ),
                        ProductPrice(price: (item['price']).toString()),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delivery Unavailable"),
          content: Text("Cannot deliver to this pin code"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductCartItems extends StatelessWidget {
  final String image;
  final String description;

  const ProductCartItems({required this.image, required this.description, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
          ),
        ),
        SizedBox(width: U_Sizes.spaceBtwItems),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ProductQuantityWithButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductQuantityWithButton({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Iconsax.minus),
          onPressed: onDecrement,
        ),
        Text('$quantity', style: Theme.of(context).textTheme.bodyLarge),
        IconButton(
          icon: Icon(Iconsax.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
