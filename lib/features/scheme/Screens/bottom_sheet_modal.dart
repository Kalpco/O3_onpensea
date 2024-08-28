import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onpensea/features/scheme/Controller/investment_controller.dart';
import 'package:onpensea/utils/constants/colors.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../utils/constants/api_constants.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

import '../../product/apiService/capturePaymentAPI.dart';
import '../../product/apiService/paymentOrderAPI.dart';
import '../../product/controller/post_transaction_Api_calling.dart';
import '../../product/models/capture_payment_success.dart';
import '../../product/models/investmentTransactionDTOList.dart';
import '../../product/models/order_api_success.dart';
import '../../product/models/razorpay_failure_response.dart';
import '../../product/models/transaction_DTO.dart';
import '../../product/models/transaction_request_wrapper_DTO.dart';
import '../models/investment_response_model.dart';
import 'ProductOrderFailSummaryPage.dart';
import 'ProductOrderSuccessSummaryPage.dart';

class BottomSheetModal extends StatefulWidget {
  final bool toggleIcon;
  final ValueChanged<bool> valueChanged;
  final Datum investment;

  const BottomSheetModal(
      {super.key,
      required this.toggleIcon,
      required this.valueChanged,
      required this.investment});

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  late bool _toggleIcon;

  // final RazorpayClient razorpayClient =
  // RazorpayClient('rzp_live_5fpmFBZvv8QIEr', 'zZsqDqQcgaJU5W30SwB63hgk');
  final RazorpayOrderAPI razorpayOrderAPI =
      RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);

  final RazorpayCapturePayment capturePayment =
      RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;
  late Razorpay _razorpay;
  static TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    _toggleIcon = widget.toggleIcon;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    bool isCaptured = await _capturePaymentRazorPay(
        paymentId: response.paymentId!,
        responseDTO: razorpaySuccessResponseDTO);
    if (isCaptured) {
      _postTransactionDetails(
        responseDTO: razorpaySuccessResponseDTO,
        paymentId: response.paymentId!,
        investment: widget.investment,
        successResponseCapturePayment: capturePaymentRazorPayResponse,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductOrderSuccessSummaryPage(
                paymentId: response.paymentId!,
                order: razorpaySuccessResponseDTO,
                investment: widget.investment)),
      );
    } else {
      // Handle capture payment failure
      print('Failed to capture payment');
      // navigate to show a snackbar message
      final loginController = Get.find<LoginController>();
      int userId = loginController.userData['userId'];

      final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
        investmentTransactionDTOList: [
          InvestmentTransactionDTOList(
            investmentId:widget.investment.investmentId,
            investmentName:widget.investment.investmentName,
            investmentAmount : (razorpaySuccessResponseDTO.amount / 100),
            createDate :  DateTime.now(),
            investmentType: "SCHEME",
          ),
        ],
        transactionDTO: TransactionDTO(
            paymentGatewayTransactionId: response.paymentId,
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
            transactionOrderId: response.orderId,
            createDate: DateTime.now()),
      ).toJson();

      await TranactionOrderAPI.postTransactionDetails(
          failedCapturePaymentDetails);
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment Error: ${response.code} - ${response.message}');
    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];


    final failedCapturePaymentDetails= TransactionRequestResponseWrapperDTO(
      investmentTransactionDTOList: [
        InvestmentTransactionDTOList(
          investmentId:widget.investment.investmentId,
          investmentName:widget.investment.investmentName,
          investmentAmount : (razorpaySuccessResponseDTO.amount / 100),
          createDate :  DateTime.now(),
          investmentType: "SCHEME",
        ),
      ],
      transactionDTO: TransactionDTO(
          userId: userId,
          transactionStatus:razorpaySuccessResponseDTO.status +
              "_" +
              response.message! +
              "_" +
              response.code.toString(),
          transactionMessage: response.message,
          createDate: DateTime.now()),
    ).toJson();

    await TranactionOrderAPI.postTransactionDetails(
        failedCapturePaymentDetails);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductOrderFailSummaryPage(
              message: response.message!, order: razorpaySuccessResponseDTO)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  String generateUniqueNumber(String userId) {
    // Get today's date
    String today = DateFormat('yyyyMMdd').format(DateTime.now());

    // Extract user-specific identifier
    String userSpecificId = userId[userId.length - 1];

    // Combine elements to form the unique number
    String uniqueNumber = "UQN$today$userSpecificId";

    return uniqueNumber;
  }

  void _postTransactionDetails(
      {required RazorpaySuccessResponseDTO responseDTO,
      required String paymentId,
      required Datum investment,
      required CapturePaymentRazorPay successResponseCapturePayment}) async {
    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];
    try {

      final transactionDetails= TransactionRequestResponseWrapperDTO(
        investmentTransactionDTOList: [
          InvestmentTransactionDTOList(
            investmentId:investment.investmentId,
            investmentName:investment.investmentName,
            investmentAmount : (responseDTO.amount / 100),
            createDate :  DateTime.now(),
            investmentType: "SCHEME",
          ),
        ],
        transactionDTO: TransactionDTO(
            paymentGatewayTransactionId: paymentId,
            userId: userId,
            transactionStatus: responseDTO.status +"_"+successResponseCapturePayment.status,
            transactionMessage: 'Payment Completed Successfully',
            transactionOrderId: successResponseCapturePayment.orderId,
            createDate: DateTime.now()),
      ).toJson();

      // Get the current date
      DateTime now = DateTime.now();

      // Create a DateFormat object with the desired format
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      // Format the current date and print the result
      String formattedDate = dateFormat.format(now);
      print(
          formattedDate); // Output will be the current date in 'yyyy-MM-dd' format

      final investmentHistoryDetalis = {
        "investmentId": investment.investmentId,
        "investmentName": investment.investmentName,
        "status": "active",
        "enrollmentDate": formattedDate,
        "totalInstallment": "12",
        "amount": (responseDTO.amount / 100).round(),
        "transactionId": paymentId,
        "userId": userId,
        "uqn": generateUniqueNumber(userId.toString()),
        "paidBy": "user"
      };

      print('Transaction Details: $transactionDetails');

      final response =
          await TranactionOrderAPI.postTransactionDetails(transactionDetails);

      final responseInvestmentHistory =
          await InvestmentController.postInvestmentHistoryDetails(
              investmentHistoryDetalis);

      if (response.statusCode == 201) {
        print('Payment details posted successfully');
        print('Response Body: ${response.body}');

        if (responseInvestmentHistory.statusCode == 201) {
          print('Payment details posted successfully');
          print('Response Body: ${responseInvestmentHistory.body}');
        }
      } else {
        print(
            'Failed to post payment details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error posting payment details: $e');
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

//   Future<void> _createOrder(
//     BuildContext context,
//     int amount,
//   ) async {
//     if (_toggleIcon) {
//       try {
//         final amountInPaise = (amount * 100).toInt();
//         final orderResponse = await razorpayOrderAPI.createOrder(
//             amountInPaise, 'INR', 'order_receipt#1');
//         print('Order : $orderResponse');
//         if (orderResponse is RazorpaySuccessResponseDTO) {
//           print('Order created successfully: $orderResponse');
//           razorpaySuccessResponseDTO = orderResponse;
//           _openCheckout(orderResponse);
//         } else if (orderResponse is RazorpayFailureResponse) {
//           print('Failed to create order: ${orderResponse.error.code}');
//           final loginController = Get.find<LoginController>();
//           int userId = loginController.userData['userId'];
//           final failedOrderDetails = {
//             'schemeId': widget.investment.investmentId,
//             'schemeName': widget.investment.investmentName,
//             'transactionStatus': orderResponse.error.description +
//                 "_" +
//                 orderResponse.error.reason +
//                 "_" +
//                 orderResponse.error.field +
//                 ":" +
//                 orderResponse.error.code,
//             'totalPrice': amount,
//             'userId': userId,
//             'schemeAmount': amount,
//             'transactionMessage': 'Failed to create order',
//           };
//           await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
//         }
//       } catch (e) {
//         print('Failed to placed order: $e');
//         // Handle the error e.g. show a Snackbar with the error message
//       }
//     } else {
// // Checkbox is not checked, show an error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Please agree to the terms and conditions before proceeding.'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//
//       // Optionally, highlight the checkbox to indicate it needs to be checked
//       setState(() {
//         // Trigger UI update if needed
//       });
//     }
//   }

  Future<void> _createOrder(
    BuildContext context,
    int amount,
  ) async {
    if (_toggleIcon) {
      try {
        final amountInPaise = (amount * 100).toInt();
        final orderResponse = await razorpayOrderAPI.createOrder(
            amountInPaise, 'INR', 'order_receipt#1');
        if (orderResponse is RazorpaySuccessResponseDTO) {
          razorpaySuccessResponseDTO = orderResponse;
          _openCheckout(orderResponse);
        } else if (orderResponse is RazorpayFailureResponse) {
          // Handle order creation failure
          print('Failed to create order: ${orderResponse.error.code}');
          final loginController = Get.find<LoginController>();
          int userId = loginController.userData['userId'];

          final failedOrderDetails= TransactionRequestResponseWrapperDTO(
            investmentTransactionDTOList: [
              InvestmentTransactionDTOList(
                investmentId:widget.investment.investmentId,
                investmentName:widget.investment.investmentName,
                investmentAmount : (razorpaySuccessResponseDTO.amount / 100),
                createDate :  DateTime.now(),
                investmentType: "SCHEME",
              ),
            ],
            transactionDTO: TransactionDTO(
                userId: userId,
                transactionStatus:orderResponse.error.description +
                    "_" +
                    orderResponse.error.reason +
                    "_" +
                    orderResponse.error.field +
                    ":" +
                    orderResponse.error.code,
                transactionMessage: 'Failed to create order',
                createDate: DateTime.now()),
          ).toJson();
          await TranactionOrderAPI.postTransactionDetails(failedOrderDetails);
        }
      } catch (e) {
        print('Failed to place order: $e');
//         // Handle the error e.g. show a Snackbar with the error message
      }
    } else {
      // Show error dialog
      _showErrorDialog(context,
          "Please agree to the terms and conditions before proceeding.");
    }
  }

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

  void _showErrorDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
      barrierDismissible:
          false, // Optional: Prevent closing dialog by tapping outside
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Wrap(children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Monthly SIP',
                    border: const OutlineInputBorder(),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                    prefixIcon: const Icon(Icons.payment),
                  ),
                  controller: amountController,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: _toggleIcon,
                        onChanged: (bool? value) {
                          setState(() {
                            if (_toggleIcon == false) {
                              _toggleIcon = true;
                            } else {
                              _toggleIcon = false;
                            }
                            print(_toggleIcon);
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I agree to the Terms & Condition and provide my consent for scheme enrollment.",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: U_Colors.chatprimaryColor,
                      side: const BorderSide(width: 1, color: Colors.white),
                    ),
                    onPressed: () {
                      if (amountController.text.isEmpty) {
                        _showErrorDialog(
                            context, "Please enter amount for monthly sip");
                      } else if (!_toggleIcon) {
                        _showErrorDialog(context,
                            "Please agree to the terms and conditions before proceeding.");
                      } else {
                        if (widget.investment.investmentName.contains("(")) {
                          print("variable");
                          //api hitting is remaining.
                        } else {
                          _createOrder(
                              context, int.parse(amountController.text));
                        }
                      }
                    },
                    child: Text(
                      'Pay Now',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
