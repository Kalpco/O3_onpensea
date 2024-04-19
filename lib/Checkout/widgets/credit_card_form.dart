
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_form_field_wrapper/text_form_field_wrapper.dart';
import 'dart:async';
import '../../UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';
import '../../UserManagement/Feature-UserLogin/Screens/login_screen.dart';
import '../widgets/validation.dart';
import 'checkout_page.dart';
import '../../Property/Feature-ShowAllDetails/Models/Properties.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import "../../Property/Feature-ShowAllDetails/Controller/PropertyController.dart";

class CreditCardForm extends StatefulWidget {
  final String? propertyName;
  final String? tokenName;
  final String? tokenCount;
  final String? tokenPrice;
  final Properties? prop;
  final String? remarks;
  final String? screenStatus;

  /// The CreditCardForm is a stateful widget containing a form and fields
  /// necessary to complete a typical credit card transaction
  const CreditCardForm({
    Key? key,
    this.countries = const ['United States'],
    this.initEmail = '',
    this.initBuyerName = '',
    this.initPhone = '',
    this.displayEmail = true,
    this.lockEmail = false,
    required this.onCardPay,
    this.payBtnKey,
    this.formKey,
    this.displayTestData = false,
    required this.propertyName,
    required this.tokenName,
    required this.tokenCount,
    required this.tokenPrice,
    required this.prop,
    required this.remarks,
    required this.screenStatus,
  }) : super(key: key);

  /// If you have a List of Countries that you would like to use to override the
  /// currently provide list of 1, being 'United States', add the list here.
  /// Warning: The credit card form does not currently adjust based on selected
  /// country's needs to verify a card. This form may not work for all countries
  final List<String> countries;

  /// Provide an email if you have it, to prefill the email field on the Credit
  /// Card form
  final String initEmail;

  /// Provide a name if you have it, to prefill the name field on the Credit
  /// Card form
  final String initBuyerName;

  /// Provide a phone number if you have it, to prefill the name field on the
  /// Credit Card form
  final String initPhone;

  /// Should the email box be displayed?
  final bool displayEmail;

  /// Should the email form field be locked? This should only be done if an
  /// [initEmail] is provided
  final bool lockEmail;

  /// Provide a function that receives [CardFormResults] as a parameter that is
  /// to be trigger once the user completes the credit card form and presses
  /// pay
  final Function(CardFormResults) onCardPay;

  /// If you would like to control the pay button state to display text or icons
  /// based on the current stage of the payment process, you will need to
  /// provide a [CardPayButtonState] key to update it.
  final GlobalKey<CardPayButtonState>? payBtnKey;

  /// You will need to provide a general [FormState] key to control, validate
  /// and save the form data based on your needs.
  final GlobalKey<FormState>? formKey;

  /// If you would like to display test data during your development, a dataset
  /// based on Stripe test data is provided. To use this date, simply mark this
  /// true.
  /// WARNING: Make sure to mark false for any release
  final bool displayTestData;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late final GlobalKey<FormState> _formKey; // = GlobalKey<FormState>();
  late Razorpay _razorpay;
  bool isSuccess = false;
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  late final GlobalKey<CardPayButtonState>? payBtnKey;

  CardBrand brand = CardBrand.n_a;

  bool get isCvvFront => brand == CardBrand.amex;

  int chosenCountryIndex = 0;

  TextEditingController cEmail = TextEditingController();
  TextEditingController cCardNumber = TextEditingController();
  TextEditingController cExpiry = TextEditingController();
  TextEditingController cSecurity = TextEditingController();
  TextEditingController cName = TextEditingController();
  TextEditingController cCountry = TextEditingController();
  TextEditingController cZip = TextEditingController();
  TextEditingController cPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsername();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    if (widget.formKey != null) {
      _formKey = widget.formKey!;
    } else {
      _formKey = GlobalKey<FormState>();
    }

    cCountry.text = widget.countries[0];
    payBtnKey = widget.payBtnKey;

    if (widget.displayTestData) {
      cEmail.text = '';
      cName.text = '';
      cCardNumber.text = '';
      cExpiry.text = '';
      cSecurity.text = '';
      cZip.text = '';
      cPhone.text = '';
    }
  }

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_wUKrMpwIAok1ZY',
      'amount': amount,
      'name': widget.propertyName,
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
    Fluttertoast.showToast(
        msg: "Payment Succesful.", toastLength: Toast.LENGTH_SHORT);
    Fluttertoast.showToast(
        msg: "Submitting request.....please wait", toastLength: Toast.LENGTH_LONG);
    Timer(Duration(seconds: 1), () async {

      var response = null;

      response = await PropertyController.postTheBuyerRequest(widget.prop!,
          username!, username!, widget.tokenCount!, widget.remarks!);

      if (response == "true") {
        Fluttertoast.showToast(
            msg: "Buy request submitted successfully", toastLength: Toast.LENGTH_SHORT);

        Timer(const Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(email: email!,)),
          );
        });
      } else {
        Fluttertoast.showToast(
            msg: "Buy request Failed", toastLength: Toast.LENGTH_SHORT);
      }
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Succesful" + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External wallet" + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
//TODO:implement dispose
    super.dispose();
    _razorpay.clear();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.initEmail.isNotEmpty) {
      cEmail.text = widget.initEmail;
    }
    if (widget.initBuyerName.isNotEmpty) {
      cName.text = widget.initBuyerName;
    }
    if (widget.initPhone.isNotEmpty) {
      String text = widget.initPhone;
      text = text.substring(0, 3) +
          '-' +
          text.substring(3, 6) +
          '-' +
          text.substring(6);
      cPhone.text = text;
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // if (widget.displayEmail)
          //   TextFormFieldWrapper(
          //     formField: TextFormField(
          //       controller: cEmail,
          //       textAlign: TextAlign.center,
          //       enabled: !widget.lockEmail,
          //       keyboardType: TextInputType.emailAddress,
          //       validator: (value) {
          //         if (value!.isNotEmpty &&
          //             EmailSubmitRegexValidator().isValid(value)) return null;
          //         return "Invalid";
          //       },
          //       decoration: const InputDecoration(
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          //           prefixIcon: Text("Email"),
          //           prefixIconConstraints:
          //               BoxConstraints(minWidth: 0, minHeight: 0),
          //           border: InputBorder.none),
          //     ),
          //   ),
          if (widget.displayEmail)
            const SizedBox(
              height: 20,
            ),
          // Row(
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
          //       child: Text('Card Information'),
          //     ),
          //   ],
          // ),
          // TextFormFieldWrapper(
          //   position: TextFormFieldPosition.top,
          //   formField: TextFormField(
          //     controller: cCardNumber,
          //     keyboardType: TextInputType.number,
          //     validator: (value) {
          //       if (CreditNumberSubmitRegexValidator().isValid(value!)) {
          //         return null;
          //       }
          //       return 'Enter a valid card number';
          //     },
          //     inputFormatters: [
          //       MaskedTextInputFormatter(
          //         mask: brand == CardBrand.amex
          //             ? 'xxxx xxxxxxx xxxx'
          //             : 'xxxx xxxx xxxx xxxx',
          //         separator: ' ',
          //       )
          //     ],
          //     decoration: const InputDecoration(
          //       hintText: '1234 1234 1234 1234',
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       border: InputBorder.none,
          //     ),
          //     onChanged: (input) {
          //       CardBrand newBrand =
          //           CardTypeRegs.findBrand(input.replaceAll(' ', ''));
          //       if (brand != newBrand) {
          //         setState(() {
          //           brand = newBrand;
          //         });
          //       }
          //     },
          //   ),
          //   suffix: _BrandsDisplay(
          //     brand: brand,
          //   ),
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextFormFieldWrapper(
          //         position: TextFormFieldPosition.bottomLeft,
          //         formField: TextFormField(
          //           controller: cExpiry,
          //           keyboardType: TextInputType.number,
          //           validator: (value) {
          //             if (CreditExpirySubmitRegexValidator().isValid(value!)) {
          //               return null;
          //             }
          //             return "Invalid";
          //           },
          //           inputFormatters: [
          //             MaskedTextInputFormatter(
          //               mask: 'xx/xx',
          //               separator: '/',
          //             )
          //           ],
          //           decoration: const InputDecoration(
          //             hintText: 'MM / YY',
          //             contentPadding:
          //                 EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //             border: InputBorder.none,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: TextFormFieldWrapper(
          //         position: TextFormFieldPosition.bottomRight,
          //         formField: TextFormField(
          //           controller: cSecurity,
          //           validator: (value) {
          //             if (CreditCvvSubmitRegexValidator().isValid(value!)) {
          //               return null;
          //             }
          //             return "Invalid";
          //           },
          //           keyboardType: TextInputType.number,
          //           inputFormatters: [
          //             MaskedTextInputFormatter(
          //               mask: brand == CardBrand.amex ? 'xxxx' : 'xxx',
          //               separator: '',
          //             )
          //           ],
          //           decoration: const InputDecoration(
          //             hintText: 'CVC',
          //             contentPadding:
          //                 EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //             border: InputBorder.none,
          //           ),
          //         ),
          //         suffix: SizedBox(
          //           height: 30,
          //           width: 30,
          //           child: isCvvFront
          //               ? Image.asset(
          //                   'assets/images/cvv_front.png',
          //                 )
          //               : Image.asset(
          //                   'assets/images/cvv_back.png',
          //                 ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
          //       child: Text('Name on card'),
          //     ),
          //   ],
          // ),
          // TextFormFieldWrapper(
          //   formField: TextFormField(
          //     controller: cName,
          //     keyboardType: TextInputType.name,
          //     validator: (input) {
          //       if (input!.isNotEmpty &&
          //           CreditNameSubmitRegexValidator().isValid(input)) {
          //         return null;
          //       } else {
          //         return 'Enter a valid name';
          //       }
          //     },
          //     decoration: const InputDecoration(
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          // Row(
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
          //       child: Text('Country or region'),
          //     ),
          //   ],
          // ),
          // TextFormFieldWrapper(
          //   position: TextFormFieldPosition.top,
          //   formField: DropdownButtonFormField(
          //     value: chosenCountryIndex,
          //     items: widget.countries
          //         .map((e) => DropdownMenuItem(
          //               child: Text(e),
          //               value: widget.countries.indexOf(e),
          //             ))
          //         .toList(),
          //     // controller: cCountry,
          //     decoration: const InputDecoration(
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       border: InputBorder.none,
          //     ),
          //     onChanged: (widget.countries.length > 1)
          //         ? (o) => {
          //               setState(() {
          //                 chosenCountryIndex = o;
          //               })
          //             }
          //         : null,
          //   ),
          // ),
          // TextFormFieldWrapper(
          //   position: TextFormFieldPosition.bottom,
          //   formField: TextFormField(
          //     controller: cZip,
          //     keyboardType: TextInputType.number,
          //     validator: (input) {
          //       if (AddressPostalSubmitRegexValidator().isValid(input!)) {
          //         return null;
          //       }
          //       return 'Enter a valid zip code';
          //     },
          //     inputFormatters: [
          //       MaskedTextInputFormatter(
          //         mask: 'xxxxx',
          //         separator: '',
          //       )
          //     ],
          //     decoration: const InputDecoration(
          //       hintText: 'ZIP',
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          // Row(
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
          //       child: Text('Phone Number'),
          //     ),
          //   ],
          // ),
          // TextFormFieldWrapper(
          //   position: TextFormFieldPosition.alone,
          //   formField: TextFormField(
          //     controller: cPhone,
          //     keyboardType: TextInputType.number,
          //     validator: (input) {
          //       input = input!.replaceAll('-', '');
          //       if (PhoneRegexValidator().isValid(input)) return null;
          //       return 'Enter a valid phone number';
          //     },
          //     inputFormatters: [
          //       MaskedTextInputFormatter(
          //         mask: 'xxx-xxx-xxxx',
          //         separator: '-',
          //       )
          //     ],
          //     decoration: const InputDecoration(
          //       // hintText: 'Phone',
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => {
              // callApi("", "", "", ""),


              openCheckout((int.parse(widget.tokenCount!) * int.parse(widget.tokenPrice!.split(".")[0])) + 20),
            },
            // onPressed: (status == CardPayButtonStatus.ready)
            //     ? () => widget.onPressed()
            //     : () => {},
            child: Text(
              "Pay",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // CardPayButton(
          //   key: payBtnKey,
          //   initStatus: CardPayButtonStatus.ready,
          //   onPressed: () {
          //     bool result = _formKey.currentState!.validate();
          //     if (result) {
          //       _formKey.currentState!.save();
          //       widget.onCardPay(CardFormResults(
          //           email: cEmail.text,
          //           cardNumber: cCardNumber.text.replaceAll(' ', ''),
          //           cardExpiry: cExpiry.text,
          //           cardSec: cSecurity.text,
          //           name: cName.text,
          //           country: cCountry.text,
          //           zip: cZip.text,
          //           phone: '+1${cPhone.text.replaceAll('-', '')}'));
          //     }
          //   },
          //   propertyName: widget.propertyName,
          //   tokenName: widget.tokenName,
          //   tokenCount: widget.tokenCount,
          //   tokenPrice: widget.tokenPrice,
          //   prop: widget.prop,
          //   remarks: widget.remarks,
          //   screenStatus: widget.screenStatus,
          // ),
        ],
      ),
    );
  }
}

// ignore: constant_identifier_names
enum CardBrand { n_a, visa, masterCard, discover, amex, diners, jcb, union }

class CardTypeRegs {
  static final RegExp _visa = RegExp(r'^4[0-9]{0,}$');
  static final RegExp _master =
      RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$');
  static final RegExp _discover = RegExp(
      r'^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$');
  static final RegExp _amex = RegExp(r'^3[47][0-9]{0,}$');
  static final RegExp _diners = RegExp(r'^3(?:0[0-59]{1}|[689])[0-9]{0,}$');
  static final RegExp _jcb = RegExp(r'^(?:2131|1800|35)[0-9]{0,}$');
  static final RegExp _union = RegExp(r'^(62|88)\d+$');

  static CardBrand findBrand(String cardNUmber) {
    if (_visa.matchAsPrefix(cardNUmber) != null) return CardBrand.visa;
    if (_master.matchAsPrefix(cardNUmber) != null) return CardBrand.masterCard;
    if (_discover.matchAsPrefix(cardNUmber) != null) return CardBrand.discover;
    if (_diners.matchAsPrefix(cardNUmber) != null) return CardBrand.diners;
    if (_amex.matchAsPrefix(cardNUmber) != null) return CardBrand.amex;
    if (_jcb.matchAsPrefix(cardNUmber) != null) return CardBrand.jcb;
    if (_union.matchAsPrefix(cardNUmber) != null) return CardBrand.union;
    return CardBrand.n_a;
  }
}

class _BrandsDisplay extends StatefulWidget {
  const _BrandsDisplay({Key? key, this.brand = CardBrand.n_a})
      : super(key: key);
  final CardBrand brand;

  @override
  _BrandsDisplayState createState() => _BrandsDisplayState();
}

class _BrandsDisplayState extends State<_BrandsDisplay> {
  bool get displayAll => (widget.brand == CardBrand.n_a);
  int counter = 0;
  bool isVisible = true;

  Widget diners = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_diners.png',
    ),
  );
  Widget jcb = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_jcb.png',
    ),
  );
  Widget union = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_union_pay.png',
    ),
  );
  Widget discover = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_discover.png',
    ),
  );
  Widget visa = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_visa.png',
    ),
  );
  Widget master = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_mastercard.png',
    ),
  );
  Widget amex = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset(
      'assets/images/card_amex.png',
    ),
  );

  Widget? image;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 3);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (timer.tick % 4 == 0) {
        setState(() {
          image = discover;
        });
      } else if (timer.tick % 4 == 1) {
        setState(() {
          image = jcb;
        });
      } else if (timer.tick % 4 == 2) {
        setState(() {
          image = diners;
        });
      } else if (timer.tick % 4 == 3) {
        setState(() {
          image = union;
        });
      }
    });
  }

  Widget get mainImage {
    switch (widget.brand) {
      case CardBrand.amex:
        return amex;
      case CardBrand.masterCard:
        return master;
      case CardBrand.discover:
        return discover;
      case CardBrand.diners:
        return diners;
      case CardBrand.jcb:
        return jcb;
      case CardBrand.union:
        return union;
      default:
        return visa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.brand != CardBrand.n_a)
        ? mainImage
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              visa,
              master,
              amex,
              Container(
                constraints: const BoxConstraints(maxWidth: 30, maxHeight: 15),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  child: image ?? discover,
                ),
              ),
            ],
          );
  }
}
