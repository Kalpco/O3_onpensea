import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onpensea/Buyer/Feature-SubmitBuyRequest/controller/BuyerController.dart';
import 'package:onpensea/Property/Feature-ShowAllDetails/Screens/PropertyDetailsScreenNew.dart';

import '../../../Property/Feature-ShowAllDetails/Models/Properties.dart';
import '../../../UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';
import '../../../UserManagement/Feature-UserLogin/Screens/login_screen.dart';
import '../controller/SellerController.dart';

enum AppbarActionType { leading, trailing }

class SellerrRequestSubmit extends StatefulWidget {
  final String screenStatus;
  final Properties prop;
  final String tokenRequested;
  final String remarks;

  SellerrRequestSubmit(
      {super.key,
      required this.screenStatus,
      required this.prop,
      required this.tokenRequested,
      required this.remarks,
      });

  @override
  State<StatefulWidget> createState() {
    return _buyerRequstSubmitState();
  }
}

class _buyerRequstSubmitState extends State<SellerrRequestSubmit> {
  Future<String>? msg;
  late String res;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msg = SellerController.postTheBuerRequest(
        widget.prop, widget.tokenRequested, widget.remarks);
    print('at screen========= ${msg} ');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _appBar,
          body: FutureBuilder<String>(
            future: msg,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final propList = snapshot.data!;
                print(" ${snapshot.data}");

                return SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$propList!",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardScreen(
                                          email: "")),
                            );
                          }, child: Text("back")),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error} '));
              } else {
                print('at circular ${msg}');
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  PreferredSize get _appBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appBarActionButton(AppbarActionType.leading),
              appBarActionButton(AppbarActionType.trailing),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarActionButton(AppbarActionType type) {
    IconData icon = Icons.shopping_cart;

    if (type == AppbarActionType.trailing) {
      icon = Icons.search;
    }
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
