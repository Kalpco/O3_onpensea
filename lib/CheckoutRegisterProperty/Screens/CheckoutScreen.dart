import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../config/CustomTheme.dart';
import '../widgets/checkout_page.dart';
import '../../Property/Feature-ShowAllDetails/Models/Properties.dart';

class CheckoutScreen extends StatefulWidget {
  final String? propName;
  final String? address;
  final String? city;
  final String? pincode;
  final String? state;
  final String? propValue;
  final String? ownerName;
  final String? ownerId;
  final String? tokenRequested;
  final String? tokenName;
  final String? tokenSymbol;
  final String? tokenCapacity;
  final String? tokenSupply;
  final String? tokenBalance;
  final XFile? image1;
  final XFile? image2;
  final XFile? image3;
  final File? saleDeed;
  final String? userName;
  final String? screenStatus;

  const CheckoutScreen({
    super.key,
    required this.propName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
    required this.tokenRequested,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCapacity,
    required this.tokenSupply,
    required this.tokenBalance,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.saleDeed,
    required this.userName,
    required this.screenStatus,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;

  final GlobalKey<CardPayButtonState> _payBtnKey =
      GlobalKey<CardPayButtonState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _nativePayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Native Pay requires setup')));
  }

  Future<void> _cashPayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cash Pay requires setup')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  @override
  void dispose() {
    _payBtnKey.currentState?.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
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
    final demoOnlyStuff = DemoOnlyStuff();

    /// RECOMENDED: A global Key to access the credit card pay button options
    ///
    /// If you want to interact with the payment button icon, you will need to
    /// create a global key to pass to the checkout page. Without this key
    /// the the button will always display 'Pay'. You may view several ways to
    /// interact with the button elsewhere within this example.

    /// REQUIRED: A function to handle submission of credit card form
    ///
    /// A function is needed to handle your caredit card api calls.
    ///
    /// NOTE: This function in our demo example is under the widget's 'build'
    /// method only becuase it needs access to an instance variable. There is
    /// no requirement to have this function built here in live code.
    Future<void> _creditPayClicked(CardFormResults results) async {
      // you can update the pay button to show somthing is happening
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.processing);

      // This is where you would implement you Third party credit card
      // processing api
      demoOnlyStuff.callTransactionApi(_payBtnKey);

      // ignore: avoid_print
      print(results);
      // WARNING: you should NOT print the above out using live code
    }

    /// REQUIRED: A list of what the user is buying
    ///
    /// A list of item will be needed to pass into the checkout page. This is a
    /// simple demo array of [PriceItem]s used to make the demo work. The total
    /// price is automatically added later.
    ///
    /// **NOTE:**
    /// It is recomended to have no more that 10 items when using the
    /// current version due to limits of scrollability
    final List<PriceItem> _priceItems = [
      PriceItem(
          name: 'Property Name',
          quantity: 1,
          totalPriceCents: 1,
          label: widget.propName),
      PriceItem(
          name: 'Property Value',
          quantity: 1,
          totalPriceCents: 8599,
          label: widget.propValue),
      PriceItem(
          name: 'Token Capacity',
          quantity: 1,
          totalPriceCents: 2499,
          label: widget.tokenCapacity),
      PriceItem(
          name: 'Owner Name',
          quantity: 1,
          totalPriceCents: 1599,
          label: widget.ownerName),
      PriceItem(
          name: 'Platform charge',
          quantity: 1,
          totalPriceCents: 1599,
          label: "20"),
    ];

    /// REQUIRED: A name representing the reciever of the funds from user
    ///
    /// Demo vendor name provided here. User's need to know who is recieving
    /// their money
    final String _payToName = widget.propName != null ? widget.propName! : "";

    /// REQUIRED: (if you are using the native pay options)
    ///
    /// Determine whether this platform is iOS. This affects which native pay
    /// option appears. This is the most basic form of logic needed. You adjust
    /// this logic based on your app's needs and the platforms you are
    /// developing for.
    final _isApple = Platform.isIOS;

    /// RECOMENDED: widget to display at footer of page
    ///
    /// Apple and Google stores typically require a link to privacy and terms when
    /// your app is collecting and/or transmitting sensitive data. This link is
    /// expected on the same page as the form that the user is filling out. You
    /// can make this any type of widget you want, but we have created a prebuilt
    /// [CheckoutPageFooter] widget that just needs the corresponding links
    const _footer = CheckoutPageFooter(
      // These are example url links only. Use your own links in live code
      privacyLink: 'https://stripe.com/privacy',
      termsLink: 'https://stripe.com/payment-terms/legal',
      note: 'Powered By RazorPay',
      noteLink: 'https://stripe.com/',
    );

    /// OPTIONAL: A function for the back button
    ///
    /// This to be used as needed. If you have another back button built into your
    /// app, you can leave this function null. If you need a back button function,
    /// simply add the needed logic here. The minimum required in a simple
    /// Navigator.of(context).pop() request
    Function? _onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null;

    // Put it all together
    return Scaffold(
      key: _scaffoldKey,
      drawer: DashboardDrawer(
          userType: userType,
          username: username,
          email: email,
          mobile: mobile,
          photo: photo),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 22,
        color: Colors.white38,

        ///shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? const ShowAllVerifyBuy(
                                    screenStatus: "buy",
                                  )
                                : const ShowAllVerifiedProperties(
                                    screenStatus: "buy",
                                  )),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.bubble_chart),
                        SizedBox(
                          height: 1,
                        ),

                        /// icon
                        Text("Buy"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? const ShowAllVerifySell(
                                    screenStatus: "sell",
                                  )
                                : const ShowAllVerifiedProperties(
                                    screenStatus: "sell",
                                  )),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.sell),
                        SizedBox(
                          height: 1,
                        ), // icon
                        Text("Sell"),

                        /// text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? ShowAllPendingProperties(
                                    screenStatus: "buy",
                                  )
                                : const RegisterPropertyOne()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.house),
                        SizedBox(
                          height: 1,
                        ),

                        /// icon
                        Text("Property"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {}, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.devices_other),
                        SizedBox(
                          height: 1,
                        ), // icon
                        Text("Others"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
        ),
        title: Text(
          username == "NA" ? "Welcome Dummy" : "Welcome ${username}",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: photo == null
                  ? const Icon(
                Icons.person,
                color: Colors.green,
              )
                  : Container(
                padding: const EdgeInsets.all(0), // Border width
                decoration: const BoxDecoration(
                    color: Colors.transparent, shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                      size: const Size.fromRadius(48), // Image radius
                      child: photo == "NA"
                          ? const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        MemoryImage(base64Decode(photo!)),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CheckoutPage(
        priceItems: _priceItems!,
        payToName: _payToName,
        displayNativePay: true,
        onNativePay: () => _nativePayClicked(context),
        displayCashPay: true,
        onCashPay: () => _cashPayClicked(context),
        isApple: _isApple,
        onCardPay: (results) => _creditPayClicked(results),
        onBack: _onBack,
        payBtnKey: _payBtnKey,
        displayTestData: true,
        footer: _footer,
        screenStatus: widget.screenStatus,
        propName: widget.propName,
        address: widget.address,
        ownerName: widget.ownerName,
        city: widget.city,
        ownerId: widget.ownerId,
        pincode: widget.pincode,
        state: widget.state,
        propValue: widget.propValue,
        tokenRequested: widget.tokenRequested,
        tokenName: widget.tokenName,
        tokenSymbol: widget.tokenSymbol,
        tokenCapacity: widget.tokenCapacity,
        tokenSupply: widget.tokenSupply,
        tokenBalance: widget.tokenBalance,
        image1: widget.image1,
        image2: widget.image2,
        image3: widget.image3,
        saleDeed: widget.saleDeed,
        userName: widget.userName,
      ),
    );
  }
}

/// This class is meant to help separate logic that is only used within this demo
/// and not expected to resemble logic needed in live code. That said there may
/// exist some logic that is help to use in live code, such as calls to the
/// [CardPayButtonState] key to update its displayed color and icon.
class DemoOnlyStuff {
  // DEMO ONLY:
  // this variable is only used for this demo.
  bool shouldSucceed = true;

  // DEMO ONLY:
  // In this demo, this function is used to delay the reseting of the pay
  // button state in order to allow the user to resubmit the form.
  // If you API calls a failing a transaction, you may need a similar function
  // to update the button from CardPayButtonStatus.fail to
  // CardPayButtonStatus.success. The user will not be able to submit another
  // payment until the button is reset.
  Future<void> provideSomeTimeBeforeReset(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.ready);
      return;
    });
  }

  Future<void> callTransactionApi(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (shouldSucceed) {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.success);
        shouldSucceed = false;
      } else {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.fail);
        shouldSucceed = true;
      }
      provideSomeTimeBeforeReset(_payBtnKey);
      return;
    });
  }
}
