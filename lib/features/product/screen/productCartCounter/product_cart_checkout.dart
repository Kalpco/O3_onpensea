import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/images_path.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../Home/widgets/DividerWithAvatar.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../scheme/Screens/ProductOrderFailSummaryPage.dart';
import '../../../scheme/Screens/ProductOrderSuccessSummaryPage.dart';
import '../../apiService/capturePaymentAPI.dart';
import '../../apiService/paymentOrderAPI.dart';
import '../../controller/getWalletAPI.dart';
import '../../controller/post_transaction_Api_calling.dart';
import '../../models/capture_payment_success.dart';
import '../../models/order_api_success.dart';
import '../../models/product_transaction_DTO_list.dart';
import '../../models/razorpay_failure_response.dart';
import '../../models/transaction_DTO.dart';
import '../../models/transaction_request_wrapper_DTO.dart';
import '../addAddress/add_address_form.dart';
import '../customeFloatingActionButton/custom_floating_action_button.dart';
import '../productHome/wallet_Product_Fail_Page.dart';
import '../productHome/wallet_Product_Success_Page.dart';

class ProductCartCheckout extends StatefulWidget {
  final List<dynamic>? cartData;
  final double finalPrice;

  ProductCartCheckout({required this.cartData,required this.finalPrice});

  @override
  State<ProductCartCheckout> createState() => _ProductCartCheckoutState();
}

class _ProductCartCheckoutState extends State<ProductCartCheckout> {
  final loginController = Get.find<LoginController>();
  final Razorpay _razorpay = Razorpay();
  final RazorpayOrderAPI razorpayOrderAPI =
  RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);
  final RazorpayCapturePayment capturePayment =
  RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;

  bool _isWalletRedeemable = false; // To track if wallet can be redeemed
  bool _isRedeemChecked = false; // To track if "Yes" is selected
  bool _isNotRedeemChecked = true;// Track selected option ("Yes" or "No")
  double walletAmount = 0.0; // Field to store wallet amount
  double _updatedTotalPrice = 0.0;
  bool _isLoading = false;
  int? selectedAddressIndex;
  Map<String, dynamic>? selectedAddressData;
  double totalFinalPrice =0.0;




  @override
  void initState() {
    super.initState();
    _fetchWalletAmount(); // Fetch wallet amount when the screen initializes
    _updatedTotalPrice = widget.finalPrice;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  final TextEditingController _couponController = TextEditingController();
  String _message = '';
  static String couponBaseUrl = '${API_CONSTANTS_1.ApiConstants.COUPON_URL}';


  Future<void> _applyCoupon() async {
    final String couponCode = _couponController.text;
    final String couponApiUrl = '$couponBaseUrl/couponCode/$couponCode';
    setState(() {
      _message = 'Applying coupon...';
    });
    try {
      final response = await http.get(
        Uri.parse(couponApiUrl),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data response $data");
        if (data['success'] == true) {
          setState(() {
            _message = (data['couponMessage'] ?? 'Coupon applied successfully!') + 'up to 2% discount';
          });
        } else {
          setState(() {
            _message = data['couponMessage'] ?? 'Invalid coupon code.';
          });
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _message = 'Invalid coupon code!';
        });
      }
      else {
        setState(() {
          _message = 'Failed to apply coupon. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
    }
  }
  Future<void> _fetchWalletAmount() async {
    try {
      int userId = loginController.userData['userId'];
      final amount = await fetchWalletAmount(userId);
      if (amount != null ) {
        setState(() {
          walletAmount = amount; // Update wallet amount
          _isWalletRedeemable = walletAmount > 0; // Check if wallet can be redeemed
        });
      } else {
        setState(() {
          _isWalletRedeemable = false; // Wallet amount fetch failed
        });
      }// Assuming fetchWalletAmount() is a method in getWalletAPI.dart
    } catch (e) {
      print('Error fetching wallet amount: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Success -> : ${response.paymentId}');
    bool isCaptured = await _capturePaymentRazorPay(
        paymentId: response.paymentId!,
        responseDTO: razorpaySuccessResponseDTO
    );

    if (isCaptured) {
      _postTransactionDetails(
        responseDTO: razorpaySuccessResponseDTO,
        paymentId: response.paymentId!,
        successResponseCapturePayment:capturePaymentRazorPayResponse,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductOrderSuccessSummaryPage(
            paymentId: response.paymentId!,
            order: razorpaySuccessResponseDTO,
            investment: null,
              addressId:selectedAddressData?['id']
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment has been done successfully ')),
      );
    } else {
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];

      final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
        productTransactionDTOList:
        widget.cartData!.map<ProductTransactionDTO>((item){
          return ProductTransactionDTO(
            productId: item['id'],
            productPrice:item['productPrice']?.toDouble(),
            makingCharges : item['productMakingCharges']?.toDouble(),
            productQuantity : item['productQuantity']?.toInt(),
            productWeight : item['productWeight']?.toDouble(),
            purity : item['purity'],
            payedFromWallet : _isRedeemChecked,
            walletAmount: walletAmount,
            createDate :  DateTime.now(),
            userId: userId,
            userAddressId: selectedAddressData?['id'],
            productPic: item['productImageUri'].toString(),
            productName: item['productName'],
            totalAmount: item['totalPrice'],
              discountedPrice: totalFinalPrice

          );
        }).toList(),
        transactionDTO: TransactionDTO(
            paymentGatewayTransactionId: response.paymentId,
            userId: userId,
            transactionStatus: razorpaySuccessResponseDTO.status+"_"+ razorpayFailureResponse.error.code +"_"+razorpayFailureResponse.error.reason+"_"+razorpayFailureResponse.error.field+":"+razorpayFailureResponse.error.description,
            transactionMessage: 'Payment created but not captured',
            transactionOrderId: response.orderId,
            payedFromWallet : _isRedeemChecked,
            walletAmount: walletAmount,
            transactionAmount: totalFinalPrice,
            userAddressId: selectedAddressData?['id'],
            couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
            isCouponApplied: _message.contains('Coupon applied') ? 'YES' : 'NO',
            createDate: DateTime.now()),
      ).toJson();

      await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductOrderFailSummaryPage(
                message: "Payment Failed",
                order: razorpaySuccessResponseDTO)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed ')),
      );
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment Error: ${response.code} - ${response.message}');

    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];

    final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
      productTransactionDTOList:
      widget.cartData!.map<ProductTransactionDTO>((item){
        return ProductTransactionDTO(
          productId: item['id'],
          productPrice:item['productPrice']?.toDouble(),
          makingCharges : item['productMakingCharges']?.toDouble(),
          productQuantity : item['productQuantity']?.toInt(),
          productWeight : item['productWeight']?.toDouble(),
          purity : item['purity'],
          payedFromWallet : _isRedeemChecked,
          walletAmount: walletAmount,
          createDate :  DateTime.now(),
          userId: userId,
          userAddressId: selectedAddressData?['id'],
          productPic: item['productImageUri'].toString(),
          productName: item['productName'],
          totalAmount: item['totalPrice'],
            discountedPrice: totalFinalPrice

        );
      }).toList(),
      transactionDTO: TransactionDTO(
          userId: userId,
          transactionOrderId: razorpaySuccessResponseDTO.id,
          transactionStatus: razorpaySuccessResponseDTO.status+"_"+ response.message!+"_"+response.code.toString(),
          transactionMessage: response.message,
          payedFromWallet: _isRedeemChecked,
          walletAmount: walletAmount,
          transactionAmount: totalFinalPrice,
          userAddressId: selectedAddressData?['id'],
          couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
          isCouponApplied: _message.contains('Coupon applied') ? 'YES' : 'NO',
          createDate: DateTime.now()),
    ).toJson();
    await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);
    print('Payment data : ${response.code} - ${response.message}');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductOrderFailSummaryPage(
              message: response.message!,
              order: razorpaySuccessResponseDTO)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  Future<void> _createOrder(BuildContext context,double myFinalAmount) async {

    if(myFinalAmount <= 0.00){
      setState(() {
        _isLoading = true; // Show the loader
      });
      if (_isLoading) // Show loading indicator when _isLoading is true
        Center(
          child: CircularProgressIndicator(),
        );
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];
      final walletOrderDetails= TransactionRequestResponseWrapperDTO(
        productTransactionDTOList:
        widget.cartData!.map<ProductTransactionDTO>((item){
          return ProductTransactionDTO(
            productId: item['id'],
            productPrice:item['productPrice']?.toDouble(),
            makingCharges : item['productMakingCharges']?.toDouble(),
            productQuantity : item['productQuantity']?.toInt(),
            productWeight : item['productWeight']?.toDouble(),
            purity : item['purity'],
            payedFromWallet : _isRedeemChecked,
            walletAmount: walletAmount,
            createDate :  DateTime.now(),
            userId: userId,
            userAddressId: selectedAddressData?['id'],
            gstCharge:item['gstCharge'],
            productPic: item['productImageUri'].toString(),
            productName: item['productName'],
            totalAmount: item['totalPrice']?.toDouble(),
              discountedPrice: totalFinalPrice

          );
        }).toList(),
        transactionDTO: TransactionDTO(
          userId: userId,
          transactionStatus: 'Wallet_Created_Captured',
          transactionMessage: 'Payment captured from wallet',
          createDate: DateTime.now(),
          paymentGatewayTransactionId:DateTime.now().millisecondsSinceEpoch.toString(),
          payedFromWallet:_isRedeemChecked,
          walletAmount:walletAmount,
          transactionAmount: totalFinalPrice,
          userAddressId: selectedAddressData?['id'],
          couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
          isCouponApplied: _message.contains('Coupon applied') ? 'YES' : 'NO',
          transactionOrderId:DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      ).toJson();
      final response =
      await TranactionOrderAPI.postTransactionDetails(walletOrderDetails);
      if (response.statusCode == 201) {
        print('Wallet Payment details posted successfully');
        print('Response Body: ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletProductSuccessPage(
              orderId: DateTime.now().millisecondsSinceEpoch.toString(),
              totalPrice:totalFinalPrice,
            ),
          ),

        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment has been done successfully ')),
        );
      } else {
        print(
            'Failed to post wallet payment details: ${response.statusCode} - ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WalletProductFailPage(
                  orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                  totalPrice:totalFinalPrice)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed from wallet ')),
        );
      }
      setState(() {
        _isLoading = false; // Show the loader
      });

    }
    else{
      try {
        final amountInPaise = (totalFinalPrice * 100).toInt();
        print("Final Amount is -> $amountInPaise");
        final  orderResponse = await razorpayOrderAPI
            .createOrder(amountInPaise, 'INR', 'order_receipt#1');
        if(orderResponse is RazorpaySuccessResponseDTO){
          print('Order created successfully: $orderResponse');
          razorpaySuccessResponseDTO = orderResponse;

          _openCheckout(orderResponse);

        }
        else if(orderResponse is RazorpayFailureResponse){
          print('Failed to create order: ${orderResponse.error.code}');
          final loginController = Get.find<LoginController>();
          int userId = loginController.userData['userId'];

          final failedOrderDetails= TransactionRequestResponseWrapperDTO(
            productTransactionDTOList:
            widget.cartData!.map<ProductTransactionDTO>((item){
              return ProductTransactionDTO(
                productId: item['id'],
                productPrice:item['productPrice']?.toDouble(),
                makingCharges : item['productMakingCharges']?.toDouble(),
                productQuantity : item['productQuantity']?.toInt(),
                productWeight : item['productWeight']?.toDouble(),
                purity : item['purity'],
                payedFromWallet : _isRedeemChecked,
                walletAmount: walletAmount,
                createDate :  DateTime.now(),
                userId: userId,
                userAddressId: selectedAddressData?['id'],
                productPic: item['productImageUri'].toString(),
                productName: item['productName'],
                totalAmount: item['totalPrice'],
                  discountedPrice: totalFinalPrice

              );
            }).toList(),
            transactionDTO: TransactionDTO(
                userId: userId,
                transactionStatus: orderResponse.error.description +"_"+orderResponse.error.reason+"_"+orderResponse.error.field+":"+orderResponse.error.code,
                transactionMessage: 'Failed to create order',
                payedFromWallet : _isRedeemChecked,
                walletAmount: walletAmount,
                transactionAmount: totalFinalPrice,
                transactionOrderId: razorpaySuccessResponseDTO.id,
                userAddressId: selectedAddressData?['id'],
                couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
                isCouponApplied: _message.contains('Coupon applied') ? 'YES' : 'NO',
                createDate: DateTime.now()),
          ).toJson();

          await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
        }

      } catch (e) {
        print('Failed to placed order : $e');
      }
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
  void _postTransactionDetails(
      {required RazorpaySuccessResponseDTO responseDTO,
        required String paymentId,
        required CapturePaymentRazorPay successResponseCapturePayment}) async {
    final loginController = Get.find<LoginController>();
    int activeUserId = loginController.userData['userId'];

    try {


      final transactionDetails= TransactionRequestResponseWrapperDTO(
        productTransactionDTOList:
        widget.cartData!.map<ProductTransactionDTO>((item){
          return ProductTransactionDTO(
            productId: item['id'],
            productPrice:item['productPrice']?.toDouble(),
            makingCharges : item['productMakingCharges']?.toDouble(),
            productQuantity : item['productQuantity']?.toInt(),
            productWeight : item['productWeight']?.toDouble(),
            purity : item['purity'],
            gstCharge: item['gstCharges']?.toDouble(),
            merchantId: item['productOwnerId']?.toInt(),
            payedFromWallet : _isRedeemChecked,
            walletAmount: walletAmount,
            createDate :  DateTime.now(),
            userId: activeUserId,
            userAddressId: selectedAddressData?['id'],
            productPic: item['productImageUri'].toString(),
            productName: item['productName'],
            totalAmount: item['totalPrice'],
              discountedPrice: totalFinalPrice

          );
        }).toList(),
        transactionDTO: TransactionDTO(
            paymentGatewayTransactionId: paymentId,
            userId: activeUserId,
            transactionStatus: responseDTO.status +"_"+successResponseCapturePayment.status,
            transactionMessage: 'Payment Completed Successfully',
            transactionOrderId: responseDTO.id,
            payedFromWallet: _isRedeemChecked,
            walletAmount: walletAmount,
            transactionAmount: totalFinalPrice,
            userAddressId: selectedAddressData?['id'],
            couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
            isCouponApplied: _message.contains('Coupon applied') ? 'YES' : 'NO',
            createDate: DateTime.now()),
      ).toJson();

      print('Transaction Details: $transactionDetails');

      final response =
      await TranactionOrderAPI.postTransactionDetails(transactionDetails);

      if (response.statusCode == 201) {
        print('Payment details posted successfully');
        print('Response Body: ${response.body}');
      } else {
        print(
            'Failed to post payment details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error posting payment details: $e');
    }
  }

  Future<bool> _capturePaymentRazorPay(
      {required String paymentId, required RazorpaySuccessResponseDTO responseDTO}) async {
    bool isSaved = false;
    try {
      final capturePaymentResponse = await capturePayment
          .capturePayment(responseDTO.amount, responseDTO.currency, paymentId);
      if(capturePaymentResponse is CapturePaymentRazorPay){
        print('Payment captured successfully: ${capturePaymentResponse}');
        capturePaymentRazorPayResponse = capturePaymentResponse;
        isSaved= true;
      }
      else if(capturePaymentResponse is RazorpayFailureResponse){
        print('Failed to capture payment: ${capturePaymentResponse.error.code}');
        razorpayFailureResponse = capturePaymentResponse;
        isSaved= false;
      }

    } catch (e) {
      print('Failed to captured order: $e');
      isSaved= false;
    }
    return isSaved;
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              // The main content of the dialog
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Image
                    Center(
                      child: Image(
                        height: 150,
                        image: AssetImage(U_ImagePath.kalpcoUpdatedLogo),
                      ),
                    ),
                    SizedBox(height: 20), // Space between image and text

                    // Text
                    Text(
                      'Get in Touch',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'For offline assistance, bulk purchase, party wear orders, bridal jewellery orders, corporate discounts & customized jewellery',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash_1.png'),
                    SizedBox(height: 10.0),
                    // Space between text and buttons
                    Text(
                      'Contact us',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () {
                            _launchURL('tel:+919987734001'); // Replace with actual phone number
                          },
                          icon: Icon(Icons.phone, size: 14, color: Colors.black),
                          label: Text('+919987734001', style: TextStyle(fontSize: 12)),
                        ),
                        // SizedBox(width: 5), // Space between buttons
                        TextButton.icon(
                          onPressed: () {
                            // Action for Email button
                            _launchURL('mailto:support@kalpco.com');
                          },
                          icon: Icon(Icons.email, size: 14, color: Colors.black),
                          label: Text('support@kalpco.com', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Close button
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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


  @override
  Widget build(BuildContext context) {
    final String deliverable = loginController.userData['isDeliverable'];
    final userData = loginController.userData;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(U_Sizes.buttonRadius),
        child: Stack(
          clipBehavior: Clip.none, // Allow the floating button to overflow the bottom bar
          children: [
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: 250,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: U_Colors.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Redeem Amount', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: U_Sizes.spaceBtwItems),
                      Text(' Rs. ${walletAmount.toStringAsFixed(2)} is available in your wallet.'),
                      SizedBox(height: U_Sizes.spaceBtwItems),

                      if (_isWalletRedeemable)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Do you want to redeem it?'),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isRedeemChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isRedeemChecked = value ?? false;
                                      _isNotRedeemChecked = !_isRedeemChecked;
                                      _updatedTotalPrice = _isRedeemChecked
                                          ? (widget.finalPrice - walletAmount).clamp(0.00, double.infinity)
                                          : widget.finalPrice;
                                    });
                                  },
                                ),
                                Text('Yes'),
                                SizedBox(width: 15),
                                Checkbox(
                                  value: _isNotRedeemChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isNotRedeemChecked = value ?? false;
                                      _isRedeemChecked = !_isNotRedeemChecked;
                                      if (_isNotRedeemChecked) {
                                        _updatedTotalPrice = widget.finalPrice;
                                      }
                                    });
                                  },
                                ),
                                Text('No'),
                              ],
                            ),
                          ],
                        ),

                      SizedBox(height: U_Sizes.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: _isLoading
                              ? SizedBox(
                            width: 24.0, // Set width
                            height: 24.0, // Set height
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                              : _message.contains('Coupon applied')
                              ? Text('Checkout \₹ ${(_updatedTotalPrice * 0.98).toStringAsFixed(2)}')
                              : Text('Checkout \₹ ${_updatedTotalPrice.toStringAsFixed(2)}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: deliverable == 'Y' ? U_Colors.chatprimaryColor : Colors.grey,
                          ),
                          onPressed: () async {
                            if (deliverable == 'Y') {
                              totalFinalPrice = _message.contains('Coupon applied')
                                  ? _updatedTotalPrice * 0.98
                                  : _updatedTotalPrice;

                              if (totalFinalPrice <= 490000.00) {
                                // Handle checkout logic here
                                setState(() {
                                  _isLoading = true; // Start loading
                                });
                                await _createOrder(context, totalFinalPrice);
                                setState(() {
                                  _isLoading = false; // Stop loading after order is created
                                });

                              } else {
                                // Handled amount dialog logic
                                await showAmountDialog(context, totalFinalPrice);

                              }
                            } else {
                              // handled alert dialog if not deliverable
                              _showAlertDialog();

                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Custom FloatingActionButton in the bottom navigation bar
            Positioned(
              right: 10, // Align it to the right as per `FloatingActionButtonLocation.endFloat`
              bottom: 100, // Adjust the vertical position to make it float over the card
              child: CustomFloatingActionButton(
                onPressed: () => _showDialog(context),
              ),
            ),
          ],
        ),
      ),


      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${loginController.userData['name'] != null ? "${loginController.userData['name']}'s" : 'Guest'} Cart Summary",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true, // Ensure it takes only the space it needs
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: widget.cartData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = widget.cartData![index];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 16.0),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black26,
                                //     blurRadius: 10.0,
                                //     spreadRadius: 2.0,
                                //     offset: Offset(2.0, 2.0),
                                //   ),
                                // ],
                              ),
                              child: Row(
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
                                        "${API_CONSTANTS_1.ApiConstants.PRODUCTS_BASE_URL}${product['productImageUri'] ?? ''}",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error, color: Colors.red, size: 50);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['productName'],
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "₹ ${(product['productPrice'] * product['productQuantity']).toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                        Text(
                                          'Quantity: ${product['productQuantity']}',
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            if (index != widget.cartData!.length - 0)
                              DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
                          ],
                        );

                      },
                    ),
                    //
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: U_Colors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('User Information', style: Theme.of(context).textTheme.bodyLarge),
                              // SizedBox(height: U_Sizes.spaceBtwItems),
                              // Text('Name: ${userData['name']}'),
                              // Text('Mobile: ${userData['mobileNo']}'),
                              // Text('Email: ${userData['email']}'),
                              Text('Address :', style: Theme.of(context).textTheme.bodyLarge),
                              SizedBox(height: U_Sizes.spaceBwtTwoSections),

                              // Horizontally scrolling addresses
                              if (userData['address'] != null && userData['address'].isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 170,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: userData['address'].length,
                                        itemBuilder: (context, index) {
                                          var address = userData['address'][index];
                                          bool isSelected = selectedAddressIndex == index;

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAddressIndex = index;
                                                selectedAddressData = userData['address'][index];
                                              });
                                              print('Selected Address: ${userData['address'][index]}');
                                              print('Selected Address ID: ${selectedAddressData?['id']}');
                                            },
                                            child: Container(
                                              width: 250,
                                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: isSelected ? U_Colors.yaleBlue : Colors.grey,
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                                color: isSelected
                                                    ? U_Colors.satinSheenGold.withOpacity(0.2)
                                                    : Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Name: ${address['name']} ${address['fatherName']} ${address['lastName']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'City: ${address['city']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'State: ${address['state']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'PinCode: ${address['pinCode']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Address: ${address['address']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Mobile: ${address['mobileNo']}',
                                                    style: TextStyle(
                                                        color:
                                                        isSelected ? U_Colors.yaleBlue : Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    // Message if no address is selected
                                    if (selectedAddressIndex == null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Please choose an address.',
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                )
                              else
                              // Message when no addresses are available
                                Text('No address available', style: TextStyle(color: Colors.grey)),

                            ],
                          ),
                        ),
                      ),
                    ),
                    DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
                    // SizedBox(height: U_Sizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: U_Colors.whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: AddAddressForm(),
                                  ),
                                ).whenComplete(() {
                                  _fetchUserData(); // Fetch user data after address is added
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: U_Colors.yaleBlue, // Set background color
                                shadowColor: Colors.transparent, // Remove shadow
                                elevation: 0,
                                side: BorderSide.none,
                              ),
                              child: Text("Add a Delivery Address"),

                            ),
                          ),

                        ),// Adjust the width as needed

                      ),
                    ),
                    //
                    SizedBox(height: U_Sizes.spaceBtwItems),
                    //Coupon Code
                    Text(
                      'Apply Coupon ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: InputDecoration(
                                hintText: 'Enter your coupon code',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _applyCoupon,
                            child: Text('Apply'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: U_Colors.yaleBlue,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _message,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _message.contains('Invalid') || _message.contains('Failed')? Colors.red : Colors.green,
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
          // DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
          // SizedBox(height: U_Sizes.spaceBtwItems),

          // User Information with Horizontally Scrollable Address Box
          // Container(
          //   width: double.infinity,
          //   child: Card(
          //     elevation: 4,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     color: U_Colors.whiteColor,
          //     child: Padding(
          //       padding: const EdgeInsets.all(15.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // Text('User Information', style: Theme.of(context).textTheme.bodyLarge),
          //           // SizedBox(height: U_Sizes.spaceBtwItems),
          //           // Text('Name: ${userData['name']}'),
          //           // Text('Mobile: ${userData['mobileNo']}'),
          //           // Text('Email: ${userData['email']}'),
          //           Text('Address :'),
          //           SizedBox(height: U_Sizes.spaceBwtTwoSections),
          //
          //           // Horizontally scrolling addresses
          //           userData['address'] != null && userData['address'].isNotEmpty
          //               ? SizedBox(
          //             height: 170,
          //             child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: userData['address'].length,
          //               itemBuilder: (context, index) {
          //                 var address = userData['address'][index];
          //                 bool isSelected = selectedAddressIndex == index;
          //
          //                 return GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       selectedAddressIndex = index;
          //                       selectedAddressData = userData['address'][index];
          //
          //                     });
          //                     print('Selected Address: ${userData['address'][index]}');
          //                     print('Selected Address: ${selectedAddressData?['id']}');
          //
          //                   },
          //                   child: Container(
          //                     width: 250,
          //                     margin: EdgeInsets.symmetric(horizontal: 8.0),
          //                     decoration: BoxDecoration(
          //                       border: Border.all(
          //                         color: isSelected ? U_Colors.yaleBlue : Colors.grey,
          //                       ),
          //                       borderRadius: BorderRadius.circular(10),
          //                       color: isSelected ? U_Colors.satinSheenGold.withOpacity(0.2) : Colors.white,
          //                     ),
          //                     padding: EdgeInsets.all(10),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('Name: ${address['name']} ${address['fatherName']} ${address['lastName']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                         SizedBox(height: 4),
          //                         Text('City: ${address['city']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                         SizedBox(height: 4),
          //                         Text('State: ${address['state']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                         SizedBox(height: 4),
          //                         Text('PinCode: ${address['pinCode']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                         SizedBox(height: 4),
          //                         Text('Address: ${address['address']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                         SizedBox(height: 4),
          //                         Text('Mobile: ${address['mobileNo']}',
          //                             style: TextStyle(
          //                                 color: isSelected ? U_Colors.yaleBlue : Colors.black)),
          //                       ],
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //           )
          //               : Text('No address available'),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
          // // SizedBox(height: U_Sizes.spaceBtwItems),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: Card(
          //       elevation: 4,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       color: U_Colors.whiteColor,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: ElevatedButton(
          //           onPressed: () async {
          //             showModalBottomSheet(
          //               context: context,
          //               isScrollControlled: true,
          //               builder: (context) => Padding(
          //                 padding: const EdgeInsets.all(16.0),
          //                 child: AddAddressForm(),
          //               ),
          //             ).whenComplete(() {
          //               _fetchUserData(); // Fetch user data after address is added
          //             });
          //           },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: U_Colors.yaleBlue, // Set background color
          //           shadowColor: Colors.transparent, // Remove shadow
          //           elevation: 0,
          //           side: BorderSide.none,
          //         ),
          //           child: Text("Add a Delivery Address"),
          //
          //         ),
          //       ),
          //
          //     ),// Adjust the width as needed
          //
          //   ),
          // )

        ],
      ),
    );

  }
  // Method to fetch updated user data after adding address
  Future<void> _fetchUserData() async {
    try {
      int userId = loginController.userData['userId'];
      final url = Uri.parse("${API_CONSTANTS_1.ApiConstants.USERS_URL}/$userId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 2006) {
          // Update user data in the login controller
          loginController.userData.value = data['data'];
          setState(() {}); // Refresh the UI with the updated data
        }
      } else {
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  Future<void> showAmountDialog(BuildContext context, double amount) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Amount Exceeds Limit!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'The amount \Rs.${amount.toStringAsFixed(2)} is greater than the allowable limit of 500,000.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('OK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  U_Colors.chatprimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

