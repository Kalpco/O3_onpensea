import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:onpensea/features/product/models/transaction_DTO.dart';
import '../../../Home/widgets/DividerWithAvatar.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:onpensea/features/product/apiService/paymentOrderAPI.dart';
import 'package:onpensea/features/product/apiService/capturePaymentAPI.dart';
import 'package:onpensea/features/product/models/order_api_success.dart';
import 'package:onpensea/features/product/models/razorpay_failure_response.dart';
import 'package:onpensea/features/product/models/capture_payment_success.dart';
import 'package:onpensea/features/product/controller/post_transaction_Api_calling.dart';
import 'package:onpensea/features/product/screen/productHome/product_Success_page.dart';
import 'package:onpensea/features/product/screen/productHome/product_Fail_Page.dart';
import 'package:onpensea/utils/constants/api_constants.dart';

import '../../models/product_transaction_DTO_list.dart';
import '../../models/products.dart';
import '../../models/transaction_request_wrapper_DTO.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductResponseDTO product;

  CheckoutScreen({required this.product});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final LoginController loginController = Get.find<LoginController>();
  final Razorpay _razorpay = Razorpay();
  final RazorpayOrderAPI razorpayOrderAPI = RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);
  final RazorpayCapturePayment capturePayment = RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
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
        product: widget.product,
        paymentId: response.paymentId!,
        successResponseCapturePayment:capturePaymentRazorPayResponse,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductOrderSuccessSummaryPage(
              paymentId: response.paymentId!,
              product: widget.product,
              order: razorpaySuccessResponseDTO
          ),
        ),
      );
    } else {
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];

      final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
        productTransactionDTOList: [
          ProductTransactionDTO(
            productId: widget.product.id,
            productPrice: widget.product.productPrice,
            gstCharge: widget.product.gstCharges,
            makingCharges : widget.product.productMakingCharges,
            productQuantity : widget.product.productQuantity,
            productWeight : widget.product.productWeight,
            purity : widget.product.purity,
            merchantId : widget.product.productOwnerId,
            payedFromWallet : false,
            createDate :  DateTime.now(),
            userId: userId,
            productPic: widget.product.productImageUri![0].toString(),
            productName: widget.product.productName,
            totalAmount: widget.product.productPrice,
          ),
        ],
        transactionDTO: TransactionDTO(
            paymentGatewayTransactionId: response.paymentId,
            userId: userId,
            transactionStatus: razorpaySuccessResponseDTO.status+"_"+ razorpayFailureResponse.error.code +"_"+razorpayFailureResponse.error.reason+"_"+razorpayFailureResponse.error.field+":"+razorpayFailureResponse.error.description,
            transactionMessage: 'Payment created but not captured',
            transactionOrderId: response.orderId,
            createDate: DateTime.now()),
      ).toJson();

      await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment Error: ${response.code} - ${response.message}');

    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];

    final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
      productTransactionDTOList: [
        ProductTransactionDTO(
          productId: widget.product.id,
          productPrice: widget.product.productPrice,
          gstCharge: widget.product.gstCharges,
          makingCharges : widget.product.productMakingCharges,
          productQuantity : widget.product.productQuantity,
          productWeight : widget.product.productWeight,
          purity : widget.product.purity,
          merchantId : widget.product.productOwnerId,
          payedFromWallet : false,
          createDate :  DateTime.now(),
          userId: userId,
          productPic: widget.product.productImageUri![0].toString(),
          productName: widget.product.productName,
          totalAmount: widget.product.productPrice,
        ),
      ],
      transactionDTO: TransactionDTO(
          userId: userId,
          transactionStatus: razorpaySuccessResponseDTO.status+"_"+ response.message!+"_"+response.code.toString(),
          transactionMessage: response.message,
          createDate: DateTime.now()),
    ).toJson();
    await TranactionOrderAPI.postTransactionDetails(failedCapturePaymentDetails);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductOrderFailSummaryPage(
              message: response.message!,
              product: widget.product,
              order: razorpaySuccessResponseDTO)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  Future<void> _createOrder(BuildContext context) async {
    try {
      final amountInPaise = (widget.product.productPrice! * 100).toInt();
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
          productTransactionDTOList: [
            ProductTransactionDTO(
              productId: widget.product.id,
              productPrice: widget.product.productPrice,
              gstCharge: widget.product.gstCharges,
              makingCharges : widget.product.productMakingCharges,
              productQuantity : widget.product.productQuantity,
              productWeight : widget.product.productWeight,
              purity : widget.product.purity,
              merchantId : widget.product.productOwnerId,
              payedFromWallet : false,
              createDate :  DateTime.now(),
              userId: userId,
              productPic: widget.product.productImageUri![0].toString(),
              productName: widget.product.productName,
              totalAmount: widget.product.productPrice,
            ),
          ],
          transactionDTO: TransactionDTO(
              userId: userId,
              transactionStatus: orderResponse.error.description +"_"+orderResponse.error.reason+"_"+orderResponse.error.field+":"+orderResponse.error.code,
              transactionMessage: 'Failed to create order',
              createDate: DateTime.now()),
        ).toJson();

        await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
      }

    } catch (e) {
      print('Failed to placed order : $e');
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
        required ProductResponseDTO product,
        required String paymentId,
        required CapturePaymentRazorPay successResponseCapturePayment}) async {
    final loginController = Get.find<LoginController>();
    int activeUserId = loginController.userData['userId'];

    try {


      final transactionDetails= TransactionRequestResponseWrapperDTO(
          productTransactionDTOList: [
            ProductTransactionDTO(
                productId: product.id,
                productPrice: product.productPrice?.toDouble(),
                gstCharge: product.gstCharges?.toDouble(),
                makingCharges : product.productMakingCharges?.toDouble(),
                productQuantity : product.productQuantity?.toInt(),
                productWeight : product.productWeight?.toDouble(),
                purity : product.purity,
                merchantId : product.productOwnerId,
                payedFromWallet : false,
                createDate :  DateTime.now(),
                userId: activeUserId,
                productPic: product.productImageUri![0].toString(),
                productName: product.productName?.toString(),
                totalAmount: product.gstCharges?.toDouble(),
            ),
          ],
          transactionDTO: TransactionDTO(
              paymentGatewayTransactionId: paymentId,
              userId: activeUserId,
              transactionStatus: responseDTO.status +"_"+successResponseCapturePayment.status,
              transactionMessage: 'Payment Completed Successfully',
              transactionOrderId: successResponseCapturePayment.orderId,
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

  @override
  Widget build(BuildContext context) {
    final userData = loginController.userData;
    final productPrice = widget.product.productPrice ?? 0.0;
    final imageUrl = "${ApiConstants.baseUrl}${widget.product.productImageUri![0]}";
    final String deliverable = loginController.userData['isDeliverable'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "My Checkout",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(U_Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                      Text('Product Information', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: U_Sizes.spaceBtwItems),
                      Image.network(
                        imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                      SizedBox(height: U_Sizes.spaceBtwItems),
                      Text('Product Name: ${widget.product.productName}'),
                      Text('Price: ₹${productPrice.toStringAsFixed(2)}'),
                      Text('Quantity: 1'), // Since it's a single product, quantity is 1
                    ],
                  ),
                ),
              ),
              SizedBox(height: U_Sizes.spaceBtwItems),

              DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),

              SizedBox(height: U_Sizes.spaceBtwItems),
              Container(
                width: double.infinity, // Adjust the width as needed
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
                        Text('User Information', style: Theme.of(context).textTheme.bodyLarge),
                        SizedBox(height: U_Sizes.spaceBtwItems),
                        Text('Name: ${userData['name']}'),
                        Text('Mobile: ${userData['mobileNo']}'),
                        Text('Address: ${userData['address']}'),
                        Text('Email: ${userData['email']}'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: U_Sizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (deliverable == 'Y') {
                      _createOrder(context);
                    } else {
                      _showAlertDialog();
                    }
                  },                  child: const Text('Checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deliverable == 'Y' ? U_Colors.chatprimaryColor : Colors.grey,
                  ),
                ),
              ),

            ],
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
