import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/Admin/Feature-VerifySell/Models/Properties.dart';
import 'package:onpensea/Admin/Feature-VerifySell/Models/Seller.dart';

import '../Screens/ShowIndividualSellScreen.dart';

class OpenContainerWrapperNew extends StatelessWidget {
  const OpenContainerWrapperNew({
    super.key,
    required this.child,
    required this.property,
    required this.screenStatus,
    required this.username,
  });

  final Widget child;
  final Seller property;
  final String screenStatus;
final String username;
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
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) =>    ShowIndividualSellScreen(property, screenStatus: screenStatus, username: username,),
    );
  }
}
