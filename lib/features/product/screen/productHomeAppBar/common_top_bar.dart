import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../Home/Screens/HomeScreen.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../authentication/screens/login/login.dart';
import '../../../profile/Screen/OrderHistory.dart';
import '../../../profile/Screen/myWallet.dart';
import '../productCartCounter/cart_counter_icon.dart';

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

  // Initialize the body parameter
  @override
  void initState() {
    super.initState();
    _setProfileImage();
  }

  void _setProfileImage() {
    final photoUrl = loginController.userData['photoUrl'];
    profileImageUrl =
        'http://103.108.12.222:11000/kalpco/version/v0.01$photoUrl';
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
      body: widget.body, // Use the body widget passed in
    );
  }
}
