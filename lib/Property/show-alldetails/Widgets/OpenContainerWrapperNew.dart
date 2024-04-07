

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import 'package:onpensea/Property/show-alldetails/Screens/PropertyDetailsScreenNew.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Property/show-alldetails/Models/Properties.dart';


class OpenContainerWrapperNew extends StatelessWidget {
  const OpenContainerWrapperNew({
    super.key,
    required this.child,
    required this.property,
    required this.screenStatus,
  });

  final Widget child;
  final Buyer property;
  final String screenStatus;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      closedColor: const Color(0xFFE5E6E8),
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 850),
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: () async  {
          final prefs = await SharedPreferences.getInstance();
          final kycStatus = prefs.getString('kycStatus');

          if (kycStatus == "N") {
            EasyLoading.showError("Please complete KYC");
          return;
          }
          print("holahomie");
          openContainer();
        }, child: child);
      },
      openBuilder: (_, __) => PropertyDetailsScreenNew(
        screenStatus: screenStatus,
        prop: property,
      ),
    );
  }
}
