import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/apiService/paymentOrderAPI.dart';
import 'package:onpensea/features/product/controller/post_transaction_Api_calling.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/razorpay_failure_response.dart';

import 'package:onpensea/features/product/screen/bottom_add_to_cart.dart';
import 'package:onpensea/features/product/screen/curvedEdgesWidget.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Dropdown_Size.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Price_Expand_Tile.dart';
import 'package:onpensea/features/product/screen/productHome/product_Fail_Page.dart';
import 'package:onpensea/features/product/screen/productHome/product_Success_page.dart';
import 'package:onpensea/features/product/screen/product_expand-tile.dart';
import 'package:onpensea/features/product/screen/product_image_slider.dart';
import 'package:onpensea/features/product/screen/product_metadata.dart';
import 'package:onpensea/features/product/screen/product_specification.dart';
import 'package:onpensea/features/product/screen/rating_n_share.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:onpensea/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:readmore/readmore.dart';

import '../../../utils/constants/api_constants.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

import '../apiService/capturePaymentAPI.dart';
import '../models/capture_payment_success.dart';
import '../models/order_api_success.dart';
import 'CheckoutScreen/CheckoutScreen.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({super.key, required this.product});

  ProductResponseDTO product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final RazorpayOrderAPI razorpayOrderAPI =
      RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);

  final RazorpayCapturePayment capturePayment =
      RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
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

    // Capture Payment through RazorPay
    bool isCaptured = await _capturePaymentRazorPay(
        paymentId: response.paymentId!,
        responseDTO: razorpaySuccessResponseDTO);

    // Save the data in Transaction Table only if payment is captured successfully : true
    if (isCaptured) {
      _postTransactionDetails(
        responseDTO: razorpaySuccessResponseDTO,
        product: widget.product,
        paymentId: response.paymentId!,
        successResponseCapturePayment: capturePaymentRazorPayResponse,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductOrderSuccessSummaryPage(
              paymentId: response.paymentId!,
              product: widget.product,
              order: razorpaySuccessResponseDTO),
        ),
      );
    } else {
      // Handle capture payment failure
      print('Failed to capture payment');
      // navigate to show a snackbar message
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];
      final failedCapturePaymentDetails = {
        'payementGatewayTransctionId': response.paymentId,
        'productId': widget.product.id,
        'isActive': widget.product.productIsActive,
        'transactionStatus': razorpaySuccessResponseDTO.status +
            "_" +
            razorpayFailureResponse.error.code +
            "_" +
            razorpayFailureResponse.error.reason +
            "_" +
            razorpayFailureResponse.error.field +
            ":" +
            razorpayFailureResponse.error.description,
        'totalPrice': widget.product.productPrice!.toInt(),
        'weight': widget.product.productWeight!.toInt(),
        'productPicFillePath': widget.product.productImageUri![0],
        'merchantId': widget.product.productOwnerId,
        'userId': userId,
        'orderId': response.orderId,
        'transactionMessage': 'Payment created but not captured',
      };
      await TranactionOrderAPI.postTransactionDetails(
          failedCapturePaymentDetails);
    }
  }

  //

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment Error: ${response.code} - ${response.message}');

    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];
    final failedCapturePaymentDetails = {
      'productId': widget.product.id,
      'isActive': widget.product.productIsActive,
      'transactionStatus': razorpaySuccessResponseDTO.status +
          "_" +
          response.message! +
          "_" +
          response.code.toString(),
      'totalPrice': widget.product.productPrice!.toInt(),
      'weight': widget.product.productWeight!.toInt(),
      'productPicFillePath': widget.product.productImageUri![0],
      'merchantId': widget.product.productOwnerId,
      'userId': userId,
      'transactionMessage': response.message,
    };
    await TranactionOrderAPI.postTransactionDetails(
        failedCapturePaymentDetails);

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

//calling Order Api here
  Future<void> _createOrder(BuildContext context) async {
    try {
      final amountInPaise = (widget.product.productPrice! * 100).toInt();
      final orderResponse = await razorpayOrderAPI.createOrder(
          amountInPaise, 'INR', 'order_receipt#1');
      if (orderResponse is RazorpaySuccessResponseDTO) {
        print('Order created successfully: $orderResponse');
        razorpaySuccessResponseDTO = orderResponse;

        _openCheckout(orderResponse);
      } else if (orderResponse is RazorpayFailureResponse) {
        print('Failed to create order: ${orderResponse.error.code}');
        final loginController = Get.find<LoginController>();
        int userId = loginController.userData['userId'];
        final failedOrderDetails = {
          'productId': widget.product.id,
          'isActive': widget.product.productIsActive,
          'transactionStatus': orderResponse.error.description +
              "_" +
              orderResponse.error.reason +
              "_" +
              orderResponse.error.field +
              ":" +
              orderResponse.error.code,
          'totalPrice': widget.product.productPrice!.toInt(),
          'weight': widget.product.productWeight!.toInt(),
          'productPicFillePath': widget.product.productImageUri![0],
          'merchantId': widget.product.productOwnerId,
          'userId': userId,
          'transactionMessage': 'Failed to create order',
        };
        await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
      }
    } catch (e) {
      print('Failed to placed order : $e');
    }
  }

//calling razorpay here
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

  //Calling transaction post API here

  void _postTransactionDetails(
      {required RazorpaySuccessResponseDTO responseDTO,
      required ProductResponseDTO product,
      required String paymentId,
      required CapturePaymentRazorPay successResponseCapturePayment}) async {
    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];

    try {
      final transactionDetails = {
        'payementGatewayTransctionId':
            paymentId + "_" + successResponseCapturePayment.id,
        'userId': userId,
        'transactionMessage': 'Payment Captured Successfully ',
        'transactionStatus':
            responseDTO.status + "_" + successResponseCapturePayment.status,
        'productId': product.id,
        'orderId': responseDTO.id + "_" + successResponseCapturePayment.orderId,
        'merchantId': product.productOwnerId,
        'productPicFillePath': product.productImageUri![0],
        'productQuantity': product.productQuantity,
        'isActive': product.productIsActive,
        'totalPrice': product.productPrice!.toInt(),
        'weight': product.productWeight!.toInt(),
      };
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

  //capture Payment
  Future<bool> _capturePaymentRazorPay(
      {required String paymentId,
      required RazorpaySuccessResponseDTO responseDTO}) async {
    bool isSaved = false;
    try {
      final capturePaymentResponse = await capturePayment.capturePayment(
          responseDTO.amount, responseDTO.currency, paymentId);
      if (capturePaymentResponse is CapturePaymentRazorPay) {
        print('Payment captured successfully: ${capturePaymentResponse}');
        capturePaymentRazorPayResponse = capturePaymentResponse;
        isSaved = true;
      } else if (capturePaymentResponse is RazorpayFailureResponse) {
        print(
            'Failed to capture payment: ${capturePaymentResponse.error.code}');
        razorpayFailureResponse = capturePaymentResponse;
        isSaved = false;
      }
    } catch (e) {
      print('Failed to captured order: $e');
      isSaved = false;
    }
    return isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
        bottomNavigationBar: BottomAddToCart(product: widget.product),
        body: SingleChildScrollView(
          child: Column(children: [
            // 1. product Image Slider
            ProductImageSlider(product: widget.product),
            // 2. product details
            Padding(
              padding: const EdgeInsets.only(
                  right: U_Sizes.defaultSpace,
                  left: U_Sizes.defaultSpace,
                  bottom: U_Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rating
                  const RatingnShare(),
                  //price title
                  ProductMetaData(product: widget.product),
                  // const SizedBox(height: U_Sizes.spaceBwtSections),
                  //product description
                  const SizedBox(height: U_Sizes.spaceBtwItems),
                  // const ProductSizeDropdown(),
                  const SizedBox(height: U_Sizes.spaceBtwItems),

                  // const ProductTitleText(title: 'Product Details',smallSize:false),
                  Text('Product Details',
                      style: Theme.of(context).textTheme.titleMedium),

                  ReadMoreText(
                    widget.product.productDescription!,
                    trimLines: 1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Divider(),
                  //  const ProductTitleText(title: 'Product Specifications',smallSize:false),
                  // Text('Product Specifications',style: Theme.of(context).textTheme.titleMedium),

                  //product detail
                  // const ProductSpecification(),

                  ProductExpandTile(product: widget.product),
                  Divider(),
                  ProductPriceExpandTile(product: widget.product),

// Inside the build method of ProductDetail
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutScreen(product: widget.product)),
                        );
                      },
                      child: const Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: U_Colors.satinSheenGold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
