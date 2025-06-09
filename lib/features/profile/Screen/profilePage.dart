import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/profile/Screen/OtherPaymentSuccesSummary.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../navigation_menu.dart';
import '../../../network/dio_client.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images_path.dart';
import '../../Admin/bottomNavigation.dart';
import '../../Home/widgets/DividerWithAvatar.dart';
import '../../Portfolio/PortfolioInitialScreen.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../product/apiService/capturePaymentAPI.dart';
import '../../product/apiService/paymentOrderAPI.dart';
import '../../product/controller/post_transaction_Api_calling.dart';
import '../../product/models/capture_payment_success.dart';
import '../../product/models/order_api_success.dart';
import '../../product/models/razorpay_failure_response.dart';
import '../../product/models/transaction_DTO.dart';
import '../../product/screen/productCartCounter/cart_counter_icon.dart';
import '../../product/screen/productHome/product_Success_page.dart';
import 'OrderHistory.dart';
import 'myWallet.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final Razorpay _razorpay = Razorpay();
  final RazorpayOrderAPI razorpayOrderAPI =
      RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);
  final RazorpayCapturePayment capturePayment =
      RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);
  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;
  final loginController = Get.find<LoginController>();
  final navController = Get.find<NavigationController>();
  final dio = DioClient.getInstance();
  String? profileImageUrl;
  bool _isLoading = false;
  String? userType;
  int? random;

  @override
  void initState() {
    super.initState();
    _nameController.text = loginController.userData['name'] ?? '';
    _emailController.text = loginController.userData['email'] ?? '';
    _phoneController.text = loginController.userData['mobileNo'] ?? '';
    _lastNameController.text = loginController.userData['lastName'] ?? '';
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _lastNameController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Success -> : ${response.paymentId}');
    bool isCaptured = await _capturePaymentRazorPay(
        paymentId: response.paymentId!,
        responseDTO: razorpaySuccessResponseDTO);

    if (isCaptured) {
      _postTransactionDetails(
        responseDTO: razorpaySuccessResponseDTO,
        paymentId: response.paymentId!,
        successResponseCapturePayment: capturePaymentRazorPayResponse,
      );
      _showSuccessSnackBar("Payment Succesfull");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtherPaymentSuccessSummaryPage(
              paymentId: response.paymentId!,
              order: razorpaySuccessResponseDTO),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed")));
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    final int userId = loginController.userData['userId'];
    final failedOrder = TransactionDTO(
      paymentGatewayTransactionId: "",
      userId: userId,
      transactionStatus: "FAILED",
      transactionMessage: response.message ?? "Order creation failed",
      transactionOrderId: "",
      payedFromWallet: false,
      transactionAmount: double.parse(_amountController.text),
      couponCode: null,
      isCouponApplied: 'NO',
      createDate: DateTime.now(),
    ).toJson();
    await TranactionOrderAPI.postOtherPayment(failedOrder, userId);
    _showErrorSnackBar("Payment Failed.");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  Future<void> _createOrder(BuildContext context, double myFinalAmount) async {
    final int amountInPaise = (myFinalAmount * 100).toInt();
    print("Creating order for ₹$myFinalAmount (₹$amountInPaise paise)");

    try {
      final response = await razorpayOrderAPI.createOrder(
        amountInPaise,
        'INR',
        'order_receipt#${DateTime.now().millisecondsSinceEpoch}', // dynamic receipt
      );
      if (response is RazorpaySuccessResponseDTO) {
        razorpaySuccessResponseDTO = response;
        print('✅ Order created: ${response.id}');
        _openCheckout(response);
      }
    } catch (e, stackTrace) {
      print('❌ Exception during order creation: $e');
      print(stackTrace);
      _showErrorSnackBar("Something went wrong while creating the order.");
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Payment Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      'Payment Successfull',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
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

  void _postTransactionDetails(
      {required RazorpaySuccessResponseDTO responseDTO,
      required String paymentId,
      required CapturePaymentRazorPay successResponseCapturePayment}) async {
    final loginController = Get.find<LoginController>();
    int activeUserId = loginController.userData['userId'];

    try {
      final successTransaction = TransactionDTO(
        paymentGatewayTransactionId: paymentId,
        userId: activeUserId,
        transactionStatus: responseDTO.status,
        transactionMessage: 'Payment Completed Successfully',
        transactionOrderId: responseDTO.id,
        payedFromWallet: false,
        transactionAmount: double.parse(_amountController.text),
        createDate: DateTime.now(),
      ).toJson();

      final response = await TranactionOrderAPI.postOtherPayment(
          successTransaction, activeUserId);

      if (response.statusCode == 201) {
        print('Payment details posted successfully');
        print('Response Body: ${response.data}');
      } else {
        print(
            'Failed to post payment details: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error posting payment details: $e');
    }
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
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'For offline assistance, bulk purchase, party wear orders, bridal jewellery orders, corporate discounts & customized jewellery',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    DividerWithAvatar(
                        imagePath: 'assets/logos/KALPCO_splash_1.png'),
                    SizedBox(height: 10.0),
                    // Space between text and buttons
                    Text(
                      'Contact us',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () {
                            _launchURL(
                                'tel:+919987734001'); // Replace with actual phone number
                          },
                          icon:
                              Icon(Icons.phone, size: 14, color: Colors.black),
                          label: Text('+919987734001',
                              style: TextStyle(fontSize: 12)),
                        ),
                        // SizedBox(width: 5), // Space between buttons
                        TextButton.icon(
                          onPressed: () {
                            // Action for Email button
                            _launchURL('mailto:support@kalpco.com');
                          },
                          icon:
                              Icon(Icons.email, size: 14, color: Colors.black),
                          label: Text('support@kalpco.com',
                              style: TextStyle(fontSize: 12)),
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

  Future<void> _deleteProfile() async {
    int userId = loginController.userData['userId'];
    String deleteApiUrl =
        '${API_CONSTANTS_1.ApiConstants.USERS_URL}/deleteUser/$userId';

    try {
      final deleteResponse = await dio.delete(deleteApiUrl);
      print('User ID: ${deleteResponse.data}');

      if (deleteResponse.statusCode == 200) {
        loginController.userData.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your account has been Deleted...'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Get.offAll(() => LoginScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete profile')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  int _generateRandomOtp() {
    // Generate a 6-digit random number
    Random randomGenerator = Random();
    return 100000 +
        randomGenerator
            .nextInt(900000); // OTP will be between 100000 and 999999
  }

  Future<void> _sendOtp() async {
    final mobileNumber = loginController.userData['mobileNo']?.toString();
    final email = loginController.userData['email']?.toString();
    final name = loginController.userData['name']?.toString() ?? '';
    print("email $email");
    print("mobile $mobileNumber");
    print("User data: ${loginController.userData}");
    print("name $name");

    random =
        _generateRandomOtp(); // Replace this with actual OTP generation logic
    print("this is the Otp for deactivating user : $random");
    print('Sending to API: email=$email, name=$name, otp=$random');

    if(mobileNumber != null && mobileNumber.isNotEmpty) {
      String otpApiUrl =
          'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=$random%20is%20your%20OTP%20for%20deleting%20account%20with%20Kalpco.%20For%20security%20reasons,%20do%20not%20share%20this%20OTP%20with%20anyone.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707172950380816178';

      try {
        final response = await http.get(Uri.parse(otpApiUrl));

        if (response.statusCode == 200) {
          _showOtpValidationDialog(); // Show OTP validation dialog after sending OTP
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send mobile OTP')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred in mobile otp : $e')),
        );
      }
    }
    else if(email != null && email.isNotEmpty)
      {
        try
            {
              final response = await dio.post(
                "${API_CONSTANTS_1.ApiConstants.USERS_URL}/accountDeletionOTP",
                data: jsonEncode({
                  "email": email,
                  "name": name,
                  "otp": random.toString(),
                }),
                options: Options(
                  headers: {
                    "Content-Type": "application/json",
                  },
                ),
              );
              if (response.statusCode == 201) {
                _showOtpValidationDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to send email OTP')),
                );
              }
            }
            catch(e){
          print('error $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occurred in email otp : $e')),
              );

            }

      }
    else{
      try
      {
        final response = await dio.post(
          "${API_CONSTANTS_1.ApiConstants.USERS_URL}/accountDeletionOTP",
          data: jsonEncode({
            "email": email,
            "name": name,
            "otp": random.toString(),
          }),
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
        if (response.statusCode == 201) {
          _showOtpValidationDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send email OTP')),
          );
        }
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred in email otp if mobile and email available : $e')),
        );

      }
    }
  }

  // void _showDeleteConfirmationDialog() {
  //   String _selectedOption = 'email'; // default selected option
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text('Delete Profile'),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text('Choose method to delete your profile:'),
  //                 ListTile(
  //                   title: Text('Email'),
  //                   leading: Radio<String>(
  //                     value: 'email',
  //                     groupValue: _selectedOption,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _selectedOption = value!;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text('SMS'),
  //                   leading: Radio<String>(
  //                     value: 'sms',
  //                     groupValue: _selectedOption,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _selectedOption = value!;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   Navigator.of(context).pop();
  //
  //                   if (_selectedOption == 'sms') {
  //                     await _sendOtp(); // Your SMS OTP method
  //                   } else if (_selectedOption == 'email') {
  //                     //await sendEmailOtp(); // You can replace this with your actual email OTP method
  //                   }
  //                 },
  //                 child: Text('Continue'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Profile'),
          content: Text('Are you sure you want to delete your profile?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _sendOtp(); // Send OTP when "Yes" is clicked
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showOtpValidationDialog() {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'OTP',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String enteredOtp = otpController.text.trim();
                Navigator.of(context).pop();
                if (enteredOtp == random.toString()) {
                  await _deleteProfile(); // Call delete API if OTP is correct
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid OTP')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserProfile() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String lastName = _lastNameController.text;

    Map<String, dynamic> updatedData = {
      "userId": loginController.userData['userId'],
      "name": name,
      "fatherName": loginController.userData['fatherName'],
      "lastName": lastName,
      "gender": loginController.userData['gender'],
      "city": loginController.userData['city'],
      "state": loginController.userData['state'],
      "email": email,
      "mobileNo": phone,
      "aadharNo": loginController.userData['aadharNo'],
      "panNo": loginController.userData['panNo'],
      "userType": loginController.userData['userType'],
      "password": loginController.userData['password'],
      "isActive": loginController.userData['isActive'],
      "companyName": loginController.userData['companyName'],
      "gstNumber": loginController.userData['gstNumber'],
      "companyAddress": loginController.userData['companyAddress'],
      "photoUrl": loginController.userData['photoUrl'],
    };

    try {
      final response = await dio.put(
        '${API_CONSTANTS_1.ApiConstants.USERS_URL}/${loginController.userData['userId']}',
        data: updatedData,
      );

      if (response.statusCode == 200) {
        loginController.userData.assignAll(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFullScreenImage(BuildContext context) {
    print(
        "Bearer ${loginController.userData['token']}${API_CONSTANTS_1.ApiConstants.USERS_URL}${loginController.userData['photoUrl']}");
    // if (profileImageUrl == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "${API_CONSTANTS_1.ApiConstants.USERS_URL}${loginController.userData['photoUrl']}",
                httpHeaders: {
                  "Authorization": "Bearer ${loginController.userData['token']}"
                },
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
              Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: U_Colors.chatprimaryColor,
          child: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: U_Colors.whiteColor,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Obx(() => Text(
                  'Welcome, ${loginController.userData['name'] ?? 'Guest'}',
                  style: TextStyle(color: Colors.white),
                )),
            backgroundColor: Colors.transparent,
            actions: [
              CartCounterIcon(
                onPressed: () {},
                iconColor: U_Colors.whiteColor,
                counterBgColor: U_Colors.black,
                counterTextColor: U_Colors.whiteColor,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: U_Colors.whiteColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: U_Colors.chatprimaryColor,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showFullScreenImage(context),
                      child: FutureBuilder<String?>(
                        future: DioClient.getAuthToken(),
                        // Fetch token dynamically
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return CircleAvatar(
                              radius: 50,
                              child:
                                  CircularProgressIndicator(), // Show loading if token is not ready
                            );
                          }

                          return CachedNetworkImage(
                            imageUrl:
                                "${API_CONSTANTS_1.ApiConstants.USERS_URL}${loginController.userData['photoUrl']}",
                            // Ensure full URL
                            httpHeaders: {
                              "Authorization": "Bearer ${snapshot.data}",
                              // Use the fetched token
                            },
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 50,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 50,
                              child:
                                  Icon(Icons.person, size: 40), // Fallback Icon
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 15), // Space between image and text
                    Text(
                      'Hello, ${loginController.userData['name'] ?? 'Guest'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  navController.selectIndex.value = 0;
                  Get.to(() => NavigationMenu());
                },
              ),
              ListTile(
                leading: Icon(Icons.explore),
                title: Text('Explore'),
                onTap: () {
                  navController.selectIndex.value = 1;
                  Get.to(() => NavigationMenu());
                },
              ),
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Investments'),
                onTap: () {
                  navController.selectIndex.value = 2;
                  Get.to(() => NavigationMenu());
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text('Portfolio'),
                onTap: () {
                  navController.selectIndex.value = 3;
                  Get.to(() => NavigationMenu());
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Order History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistory()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.wallet),
                title: Text('My Wallet'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Mywallet()),
                  );
                },
              ),
              if (userType == "M" || userType =="A")
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Admin '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigation()),
                    );
                  },
                ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Get.find<LoginController>().logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: Card(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showFullScreenImage(context),
                child: FutureBuilder<String?>(
                  future: DioClient.getAuthToken(), // Fetch token dynamically
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return CircleAvatar(
                        radius: 50,
                        child:
                            CircularProgressIndicator(), // Show loading if token is not ready
                      );
                    }

                    return CachedNetworkImage(
                      imageUrl:
                          "${API_CONSTANTS_1.ApiConstants.USERS_URL}${loginController.userData['photoUrl']}",
                      // Ensure full URL
                      httpHeaders: {
                        "Authorization": "Bearer ${snapshot.data}",
                        // Use the fetched token
                      },
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 40), // Fallback Icon
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileOption(
                    icon: Icons.supervised_user_circle,
                    text: 'Portfolio',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PortfolioScreen()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Iconsax.user_add,
                    text: 'Update Profile',
                    onTap: () => _showUpdateInfoSheet(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileOption(
                    icon: Icons.history,
                    text: 'Order History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHistory()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.delete_forever,
                    text: 'Delete Profile',
                    onTap: () {
                      _showDeleteConfirmationDialog();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileOption(
                    icon: Icons.wallet,
                    text: 'My Wallet',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Mywallet()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      Get.find<LoginController>().logout();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 12, 5),
                    child: _buildProfileOption(
                      icon: Iconsax.user_add,
                      text: 'Other Payments',
                      onTap: () => _showUpdateOtherPaymentsSheet(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.25,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone'),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _updateUserProfile();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                            backgroundColor: U_Colors.chatprimaryColor,
                          ),
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateOtherPaymentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Amount in Rupees',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final text = _amountController.text.trim();

                        if (text.isEmpty) {
                          Get.snackbar(
                            'Missing Amount',
                            'Please enter an amount.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 2),
                          );
                          return;
                        }

                        final parsedAmount = double.tryParse(text);

                        if (parsedAmount == null || parsedAmount <= 0) {
                          Get.snackbar(
                            'Invalid Amount',
                            'Please enter a valid amount greater than 0.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 2),
                          );
                          return;
                        }

                        Navigator.pop(context); // Close the bottom sheet
                        await _createOrder(context, parsedAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: U_Colors.chatprimaryColor,
                      ),
                      child: const Text('Pay'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
