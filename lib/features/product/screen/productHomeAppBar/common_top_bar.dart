import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../commons/config/api_constants.dart';
import '../../../../navigation_menu.dart';
import '../../../../network/dio_client.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/jwt/services/jwt_service.dart';
import '../../../Admin/bottomNavigation.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../authentication/screens/login/login.dart';
import '../../../profile/Screen/OrderHistory.dart';
import '../../../profile/Screen/myWallet.dart';
import '../productCartCounter/cart_counter_icon.dart';

class CommonTopAppBar extends StatefulWidget {
  final Widget body;

  const CommonTopAppBar({super.key, required this.body});

  @override
  State<CommonTopAppBar> createState() => _CommonTopAppBarState();
}

class _CommonTopAppBarState extends State<CommonTopAppBar> {
  final loginController = Get.find<LoginController>();
  final navController = Get.find<NavigationController>();
  var profileImagePath = ''.obs; // Reactive state for image path
  var isLoading = false.obs; // Loading state
  String? userType;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // Load profile image on initialization
  }

  /// **🔹 Fetch Profile Image with JWT Authentication**
  Future<void> _fetchProfileImage() async {
    userType = loginController.userData['userType'];
    print("userType:$userType");

    isLoading.value = true;
    String? photoUrl = loginController.userData['photoUrl'];
    if (photoUrl == null || photoUrl.isEmpty) {
      profileImagePath.value = ''; // No profile image available
      isLoading.value = false;
      return;
    }

    String imageUrl = '${ApiConstants.USERS_URL}$photoUrl';
    String? token = await JwtService.getToken();

    if (token != null) {
      try {
        Dio dio = Dio();
        final response = await dio.get(
          imageUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            responseType: ResponseType.bytes,
          ),
        );

        // Save image to local storage
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/profile.jpg');
        await file.writeAsBytes(response.data);

        profileImagePath.value = file.path; // Update UI
      } catch (e) {
        print('❌ Error fetching profile image: $e');
      }
    }
    isLoading.value = false;
  }

  /// **🔹 Show Full Screen Image**
  void _showFullScreenImage(BuildContext context) {
    if (profileImagePath.value.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            children: [
              Image.file(
                File(profileImagePath.value),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: U_Colors.chatprimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: U_Colors.whiteColor),
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
                SizedBox(width: 16),
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
                decoration: BoxDecoration(color: U_Colors.chatprimaryColor),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showFullScreenImage(context),
                      child: Obx(() {
                        if (isLoading.value) {
                          return const CircularProgressIndicator(
                              color: Colors.white);
                        }

                        if (profileImagePath.value.isNotEmpty) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(
                                File(profileImagePath.value)), // ✅ Safe usage
                          );
                        } else {
                          return const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/logos/userprofile.webp'),
                            backgroundColor: Colors.transparent,
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Hello, ${loginController.userData['name'] ?? 'Guest'}',
                      style: const TextStyle(
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
                title: Text('Investment'),
                onTap: () {
                  navController.selectIndex.value = 2;
                  Get.to(() => NavigationMenu());
                },
              ),
              if (loginController.userData["userId"] == 0)
                ListTile(
                  leading: Icon(Icons.arrow_back_rounded),
                  title: Text('Back'),
                  onTap: () async {
                    // **Clear JWT Token**
                    await JwtService.deleteToken(); // Remove the saved token
                    DioClient.token = null; // Reset the token globally in Dio client
                    loginController.userData.clear(); // Clear guest user data
                    loginController.userType.value = ''; // Reset user type

                    print("✅ Guest token cleared successfully!");

                    // Navigate to Login Page
                    navController.selectIndex.value = 2;
                    Get.off(() => LoginScreen()); // Use `off` to remove previous history
                  },
                ),

              if (loginController.userData["userId"] != 0) ...[
                ListTile(
                  leading: const Icon(Icons.supervised_user_circle),
                  title: const Text('Portfolio'),
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
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Get.find<LoginController>().logout();
                  },
                ),
              ],
              if (userType == "M")
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Admin'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigation()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      body: widget.body,
    );
  }
}
