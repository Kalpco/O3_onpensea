import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Models/Properties.dart';

import '../Screens/PropertyDetailsScreenNew.dart';

class OpenContainerWrapperNew extends StatelessWidget {
  const OpenContainerWrapperNew({
    super.key,
    required this.child,
    required this.property,
    required this.screenStatus,
  });

  final Widget child;
  final Properties property;
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
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) => PropertyDetailsScreenNew(
        screenStatus: screenStatus,
        prop: property,
      ),
    );
  }
}
