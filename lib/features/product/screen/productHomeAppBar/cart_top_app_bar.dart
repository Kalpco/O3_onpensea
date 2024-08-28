import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/cart_home_app_bar.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../authentication/screens/login/login.dart';
import '../../../profile/Screen/OrderHistory.dart';
import '../../../profile/Screen/myWallet.dart';
import '../productCartCounter/cart_counter_icon.dart';

class CartTopAppBar extends StatefulWidget {
  final Widget body; // Add a body parameter

  const CartTopAppBar({super.key, required this.body});

  @override
  State<CartTopAppBar> createState() => _CartTopAppBarState();
}

class _CartTopAppBarState extends State<CartTopAppBar> {
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
                Text(
                  "${loginController.userData['name'] != null ? "${loginController.userData['name']}'s" : 'Guest'} Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16), // Space between search bar and icons
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CartHomeAppBar(
                        onPressed: () {},
                        iconColor: U_Colors.whiteColor,
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
