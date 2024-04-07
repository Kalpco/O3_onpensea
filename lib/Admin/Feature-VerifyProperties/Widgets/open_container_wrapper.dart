import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Models/Properties.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Screens/ShowIndividualProperty.dart';
import '../Models/Product.dart';


class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    super.key,
    required this.child,
    required this.product,
    required this.screenStatus,
  });

  final Widget child;
  final Product product;
  final String screenStatus;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      closedColor: const Color(0xFFE5E6E8),
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 850),
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) =>    ShowIndividualProperty(product as Properties, screenStatus: screenStatus, username: '',),
    );
  }
}