import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/Admin/bottomNavigation.dart';
import 'package:onpensea/features/scheme/Screens/digigold/screens/digigold_main.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../Home/Screens/HomeScreen.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../authentication/screens/login/login.dart';
import '../../../profile/Screen/OrderHistory.dart';
import '../../../profile/Screen/myWallet.dart';
import '../productCartCounter/cart_counter_icon.dart';
import 'package:http/http.dart' as http; // Import the http package

class CommonTopAppBar extends StatefulWidget {
  final Widget body; // Add a body parameter

  const CommonTopAppBar({super.key, required this.body});

  @override
  State<CommonTopAppBar> createState() => _CommonTopAppBarState();
}

class _CommonTopAppBarState extends State<CommonTopAppBar> {
  String? profileImageUrl;
  final loginController = Get.find<LoginController>();
  final navController = Get.find<NavigationController>();
  String? userType;
  var userRole = ''.obs;
  void setUserRole(String role) {
    userRole.value = role;
  }
  // Initialize the body parameter
  @override
  void initState() {
    super.initState();
    _setProfileImage();
  }

  void _setProfileImage() {
    userType = loginController.userData['userType'];
    print("userType:$userType");

    if (loginController.userData['photoUrl'] != null) {
      String photoUrl = loginController.userData['photoUrl'];
      profileImageUrl =
      '${ApiConstants.USERS_URL}$photoUrl';
    } else {
      profileImageUrl = "null";
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
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
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

  Future<void> _deleteProfile() async {
    String userId = loginController.userData['userId'].toString();
    String url = '${ApiConstants.USERS_URL}/deleteUser/$userId';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {

        loginController.userData.clear();

        Get.offAll(() => LoginScreen());
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete profile')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
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
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await _deleteProfile(); // Call the delete function
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Increased height for search bar
        child: AppBar(
          backgroundColor: U_Colors.chatprimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: U_Colors.whiteColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16), // Space between search bar and icons
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CartCounterIcon(
                        onPressed: () {},
                        iconColor: U_Colors.whiteColor,
                        counterBgColor: U_Colors.black,
                        counterTextColor: U_Colors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                      child: profileImageUrl != "null"
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
                          : const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        AssetImage('assets/logos/userprofile.webp'),
                        backgroundColor: Colors.transparent,
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

              if (loginController.userData["userId"] == 0)
                ListTile(
                  leading: Icon(Icons.arrow_back_rounded),
                  title: Text('Back'),
                  onTap: () {
                    navController.selectIndex.value = 2;
                    Get.to(() => LoginScreen());
                  },
                ),
              // Conditional Tiles
              if (loginController.userData["userId"] != 0) ...[
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
                    title: Text('Admin'),
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
                // ListTile(
                //   leading: Icon(Icons.logout),
                //   title: Text('digi gold'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => DigiGoldMain()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.delete),
                //   title: Text('Delete Profile'),
                //   onTap: _showDeleteConfirmationDialog,
                // ),
              ],
            ],
          ),
        ),
      ),
      body: widget.body, // Use the body widget passed in
    );
  }
}
