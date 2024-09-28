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
import '../../Portfolio/PortfolioInitialScreen.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

import '../../product/screen/productCartCounter/cart_counter_icon.dart';
import 'OrderHistory.dart';
import 'myWallet.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();

  final navController = Get.find<NavigationController>();
  final Dio _dio = Dio();
  String? profileImageUrl;
  String? userType;


  @override
  void initState() {


    super.initState();
    final loginController = Get.find<LoginController>();
    _nameController.text = loginController.userData['name'] ?? '';
    _emailController.text = loginController.userData['email'] ?? '';
    _phoneController.text = loginController.userData['mobileNo'] ?? '';
    // _addressController.text = loginController.userData['address'] ?? '';
    _lastNameController.text = loginController.userData['lastName'] ?? '';

    _setProfileImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _lastNameController.dispose();
    _userTypeController.dispose();

    super.dispose();
  }

  void _setProfileImage() {
    final loginController = Get.find<LoginController>();
    String photoUrl = loginController.userData['photoUrl'];

    print('photourl: $photoUrl');
    profileImageUrl =
        '${ApiConstants.USERS_URL}$photoUrl';
    print("api: ${ApiConstants.USERS_URL}");
    print("profile image: $profileImageUrl");




    userType = loginController.userData['userType'];
    print("userType:$userType");

    setState(() {});
  }

  Future<void> _updateUserProfile() async {
    final loginController = Get.find<LoginController>();

    // Collect updated data from the text controllers
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String lastName=_lastNameController.text;

    // Prepare the data to be sent in the PUT request
    Map<String, dynamic> updatedData = {
      "userId": loginController.userData['userId'],
      "name": name,
      "fatherName": loginController.userData['fatherName'],
      "lastName": lastName,
      "gender": loginController.userData['gender'],
      "city": loginController.userData['city'],
      "state": loginController.userData['state'],
      "address": address,
      "email": email,
      "mobileNo": phone,
      "aadharNo": loginController.userData['aadharNo'],
      "panNo": loginController.userData['panNo'],
      "userType": loginController.userData['userType'],
      "password": loginController.userData['password'],
      "isActive": loginController.userData['isActive'],
      "photoUrl": loginController.userData['photoUrl'],
      "companyName": loginController.userData['companyName'],
      "gstNumber": loginController.userData['gstNumber'],
      "companyAddress": loginController.userData['companyAddress'],
    };

    // Perform the PUT request to update the user profile
    try {
      final response = await _dio.put(
        '${ApiConstants.USERS_URL}/${loginController.userData['userId']}',
        data: updatedData,
      );

      if (response.statusCode == 200) {
        // Update the login controller's userData with the new data
        loginController.userData.assignAll(updatedData);

        // Show a success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile Updated'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showUpdateInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          // Initial size is 75% of the screen
          minChildSize: 0.25,
          // Minimum size can be adjusted
          maxChildSize: 1.0,
          // Maximum size can be adjusted
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
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
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _updateUserProfile();
                          Navigator.pop(context);
                          // Close the bottom sheet
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
            );
          },
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
                placeholder: (context, url) => const CircularProgressIndicator(),
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

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
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
            //leading: IconButton(         icon: Icon(Icons.arrow_back,color: Colors.white), onPressed: () { Navigator.pop(context); }, ),// Default back button icon         onPressed: () {           Navigator.pop(context);,
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
                      child: profileImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: profileImageUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    SizedBox(height: 15), // Space between image and text
                    Text(
                      'Hello, ${loginController.userData['name'] ?? 'Guest'}',
                      // Replace with actual name if available
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
              if(userType=="A")
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin(profilePage)'),
                onTap: () {

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

                    // Handle Portfolio tap
                  },
                ),
                SizedBox(width: 20),
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
                SizedBox(width: 20),
                _buildProfileOption(
                  icon: Icons.favorite,
                  text: 'Wishlist',
                  onTap: () {
                    // Handle Wishlist tap
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
                SizedBox(width: 20),
                _buildProfileOption(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    // Handle Wishlist tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
