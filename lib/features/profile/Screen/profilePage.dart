import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/common_top_bar.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../Admin/bottomNavigation.dart';
import '../../Portfolio/PortfolioInitialScreen.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../product/screen/productCartCounter/cart_counter_icon.dart';
import 'OrderHistory.dart';
import 'myWallet.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final loginController = Get.find<LoginController>();
  final navController = Get.find<NavigationController>();
  final Dio _dio = Dio();
  String? profileImageUrl;
  String? userType;
  int? random;

  @override
  void initState() {
    super.initState();
    _nameController.text = loginController.userData['name'] ?? '';
    _emailController.text = loginController.userData['email'] ?? '';
    _phoneController.text = loginController.userData['mobileNo'] ?? '';
    _lastNameController.text = loginController.userData['lastName'] ?? '';
    _setProfileImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _deleteProfile() async {
    String userId = loginController.userData['userId'].toString();
    String deleteApiUrl =
        '${ApiConstants.USERS_URL}deleteUser/$userId';

    try {
      final deleteResponse = await http.delete(Uri.parse(deleteApiUrl));

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
    String mobileNumber = loginController.userData['mobileNo'];
    random =
        _generateRandomOtp(); // Replace this with actual OTP generation logic
    print("this id the Otp for deactivating$random");
    String otpApiUrl =
        'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=$random%20is%20your%20OTP%20for%20deleting%20account%20with%20Kalpco.%20For%20security%20reasons,%20do%20not%20share%20this%20OTP%20with%20anyone.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707172950380816178';

    try {
      final response = await http.get(Uri.parse(otpApiUrl));

      if (response.statusCode == 200) {
        _showOtpValidationDialog(); // Show OTP validation dialog after sending OTP
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

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

  void _setProfileImage() {
    String photoUrl = loginController.userData['photoUrl'];
    profileImageUrl = '${ApiConstants.USERS_URL}$photoUrl';
    userType = loginController.userData['userType'];
    setState(() {});
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
    };

    try {
      final response = await _dio.put(
        '${ApiConstants.USERS_URL}/${loginController.userData['userId']}',
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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: profileImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
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
     drawer:    Drawer(
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
                        child: profileImageUrl != null
                            ? CachedNetworkImage(
                          imageUrl: profileImageUrl!,
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 50,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                            : CircleAvatar(
                          radius: 50,
                          child: CircularProgressIndicator(),
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
                if (userType == "M")
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text('Admin '),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavigation()),
                      );
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showFullScreenImage(context),
              child: profileImageUrl != null
                  ? CachedNetworkImage(
                imageUrl: profileImageUrl!,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
                  : CircleAvatar(
                radius: 50,
                child: CircularProgressIndicator(),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),






            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     _buildProfileOption(
            //       icon: Icons.delete_forever,
            //       text: 'Delete Profile',
            //       onTap: () {
            //         _showDeleteConfirmationDialog();
            //       },
            //     ),
            //   ],
            // ),
          ],
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
}
