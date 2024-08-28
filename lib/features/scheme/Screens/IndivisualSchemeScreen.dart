import 'package:flutter/material.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:onpensea/features/scheme/Models/ResponseDTO.dart';
import 'package:onpensea/features/scheme/Screens/all_scheme_screen.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../navigation_menu.dart';
import '../Models/transaction_dto.dart';
import '../Models/transaction_request_dto.dart';
import '../Widgets/carousel_slider.dart';
import '../Widgets/page_wrapper.dart';
import '../service/transaction_service.dart';

class IndivisualSchemeScreen extends StatefulWidget {
  final Scheme singleScheme;

  const IndivisualSchemeScreen({super.key, required this.singleScheme});

  @override
  State<IndivisualSchemeScreen> createState() =>
      _IndivisualSchemeScreen();
}

class _IndivisualSchemeScreen extends State<IndivisualSchemeScreen> {
  static TextEditingController amountController = TextEditingController();
  static TextEditingController remarksController = TextEditingController();
  late Razorpay _razorpay;
  var totalInvested = 0;
  var valueAtRedemption = 0;
  int _selectedRadioButton = 1;
  bool isChecked = false;
  bool isSuccess = false;
  bool isTransactionComplete = false;
  TransactionResponseDTO? transactionResponseDTO;
  int? transactionId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initiateRazorPay();
    amountController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState!.dispose();
    amountController.dispose();
    _razorpay.clear();
    // remarksController.dispose;
  }

  void initiateRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      // 'key': 'rzp_live_5fpmFBZvv8QIEr',
      'key': 'rzp_test_wUKrMpwIAok1ZY',
      'amount': amount,
      'name': widget.singleScheme.schemeName,
      'prefill': {'contact ': '9029995819', 'email': 'finace.chand@gmail.com'},
      'external': {
        'wallets': ['paytm', 'gpay', 'phonepe']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    _showModal(response, "success", PaymentFailureResponse(1, "message", null));
    setState(() {
      isSuccess = true;
      isTransactionComplete = true;
    });
  }

  void _showModal(PaymentSuccessResponse response, String status,
      PaymentFailureResponse responseFail) {
    Future<void> future = showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: status == "success"
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 50.0,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Transaction Successful",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Payment Id: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    response.paymentId.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Amount Paid: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    amountController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Scheme Name: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.singleScheme!.schemeName!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Enrollment Date: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yMd').format(new DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Maturity Date: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yMd').format(new DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Installment Paid: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "1",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Transaction Failed",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Payment Id: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    responseFail.message.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Transaction Amount: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "1000",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Scheme Name: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.singleScheme.schemeName!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Transaction Date: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yMd').format(new DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    print('modal closed');
    Fluttertoast.showToast(
        msg: "Redirecting...", toastLength: Toast.LENGTH_SHORT);
    Future.delayed(const Duration(seconds: 1), () {
      // code to be executed after 2 seconds
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NavigationMenu(),
        ),
      );
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    _showModal(PaymentSuccessResponse("", "", "", null), "fail", response);
    setState(() {
      isSuccess = false;
      isTransactionComplete = true;
    });
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External wallet" + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void calculate(String amount) {
    var months = 11;
    var newtotalInvested = int.parse(amount) * months;
    var newvalueAtRedemption = newtotalInvested + (int.parse(amount));
    setState(() {
      totalInvested = newtotalInvested;
      valueAtRedemption = newvalueAtRedemption;
    });
  }

  Future<void> postTransaction(TransactionDto transactionDto) async {
    final transactionService = TransactionService();
    transactionResponseDTO =
    await transactionService.postTransaction(transactionDto);
    setState(() {
      transactionId = transactionResponseDTO!.data!.transactionId!;
      print("TransactionId: $transactionId");
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return

      Scaffold(
        key: _formKey,
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                productPageView(width, height, widget.singleScheme!),
                schemeHeading(widget.singleScheme!),
                schemeRules(widget.singleScheme!),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0XFFF7F1E3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BENEFIT CALCULATOR",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: const Color(0xff182C61),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        schemeExamples(widget.singleScheme),
                        const SizedBox(height: 50),
                        schemeCalculator(
                            amountController, totalInvested, valueAtRedemption),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 5, // Space between underline and text
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0, // Underline thickness
                              ))),
                      child: Text(
                        "Download scheme details",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {},
                ),
                const SizedBox(
                  height: 40,
                ),
                enrollUser(),
                const SizedBox(
                  height: 60,
                ),
                termsAndCondition(),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // foreground (text) color
                      backgroundColor:
                      const Color(0xff2C2C54), // background color
                    ),
                    onPressed: () {
                      postTransaction(TransactionDto(
                          isActive: "isActive",
                          interestRate: "interestRate",
                          schemeAmount: "schemeAmount",
                          merchantId: "merchantId",
                          userId: "userId",
                          payementGatewayTransctionId: "payementGatewayTransctionId",
                          schemeId: "schemeId",
                          transactionStatus: "transactionStatus",
                          transactionMessage: "transactionMessage"));

                      // if (amountController.text.toString() == "" &&
                      //     isChecked == false) {
                      //   Fluttertoast.showToast(
                      //       msg: "Enter amount and accept term and Condition",
                      //       toastLength: Toast.LENGTH_SHORT);
                      // } else if (isChecked == false) {
                      //   Fluttertoast.showToast(
                      //       msg: "Accept terms and Condition",
                      //       toastLength: Toast.LENGTH_SHORT);
                      // } else if (amountController.text.toString() == "") {
                      //   Fluttertoast.showToast(
                      //       msg: "Enter amount",
                      //       toastLength: Toast.LENGTH_SHORT);
                      // } else {
                      //   openCheckout(int.parse(amountController.text));
                      // }
                    },
                    child: Text(
                      "Make Payment",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget enrollUser() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.yellow,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ]),
          child: Text(
            "Let's get you enrolled for the scheme",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<int>(
              value: 1,
              groupValue: _selectedRadioButton,
              onChanged: (value) {
                setState(() {
                  _selectedRadioButton = value!;
                });
              },
            ),
            const Text(
              'Existing User',
              style: TextStyle(fontSize: 17.0),
            ),
            SizedBox(width: 10),
            Radio<int>(
              value: 2,
              groupValue: _selectedRadioButton,
              onChanged: (value) {
                setState(() {
                  _selectedRadioButton = value!;
                });
              },
            ),
            const Text(
              'New User',
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: _selectedRadioButton == 1
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Email Address: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Email Address: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Aadhar Number: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Pan Number: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Password: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Kindly register first to continue. "),
              TextButton(
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 5, // Space between underline and text
                  ),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.blueAccent,
                            width: 2.0, // Underline thickness
                          ))),
                  child: Text(
                    "Register here",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () async {},
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget termsAndCondition() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          Expanded(
            child: Text(
              "I agree to the Terms & Condition and provide my consent for scheme enrollment.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget schemeCalculator(TextEditingController amountController,
      var totalInvested, var valueAtRedemption) {
    print(totalInvested);
    print(valueAtRedemption);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          "Enter Monthly Payments",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: const Color(0xff182C61),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter amount",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black87,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.black87,
                  width: 1.5,
                )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black87,
                width: 2,
              ),
            ),
          ),
          controller: amountController,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 250,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, // foreground (text) color
              backgroundColor: const Color(0xff2C2C54), // background color
            ),
            onPressed: () => calculate(amountController.text),
            child: Text(
              "Calculate",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: const Color(0xffEEC670),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Total Invested",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: totalInvested.toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Value at redemption:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: valueAtRedemption.toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, color: Colors.black),
    ),
  );
}

Widget productPageView(double width, double height, Scheme singleScheme) {
  List<String> listImages = [
    singleScheme.schemaImageUri!,
    singleScheme.schemaImageUri!,
    singleScheme.schemaImageUri!
  ];

  return SizedBox(
    height: height * 0.42,
    width: width,
    child: CarouselSlider(items: listImages),
  );
}

Widget schemeHeading(Scheme scheme) {
  List<String>? schemeDescriptions = scheme.schemeDescription?.split("|");

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          "${scheme.schemeName}",
          style: const TextStyle(shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.yellow,
              offset: Offset(1, 3),
            ),
          ], fontSize: 32, color: Colors.black, fontWeight: FontWeight.w900),
        ),
        Text(
          "Offered by ${scheme.schemeOwnerName}",
          style: const TextStyle(
              fontSize: 28,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          textAlign: TextAlign.center,
          "${schemeDescriptions?[0]}",
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        for (var i = 1; i < schemeDescriptions!.length; i++)
          Text(
            schemeDescriptions[i],
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              color: Colors.black45,
            ),
          ),
        const SizedBox(
          height: 25,
        ),
      ],
    ),
  );
}

Widget schemeRules(Scheme scheme) {
  List<String>? schemeRules = scheme.schemeRules?.split("|");
  return Padding(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rules",
          style: GoogleFonts.poppins(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        for (var i = 1; i < schemeRules!.length; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$i. ${schemeRules![i]}",
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ),
        const SizedBox(
          height: 40,
        ),
      ],
    ),
  );
}

Widget schemeExamples(Scheme scheme) {
  List<String> schemeExamples = scheme.schemeExtraBenefits!.split("|");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < schemeExamples.length; i++)
        Text(
          schemeExamples[i],
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: const Color(0xff182C61),
          ),
        ),
    ],
  );
}
