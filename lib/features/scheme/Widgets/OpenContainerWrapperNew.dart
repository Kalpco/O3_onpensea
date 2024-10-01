import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';

import '../Screens/investment_home_page.dart';

class OpenContainerWrapperNew extends StatelessWidget {
  const OpenContainerWrapperNew({
    super.key,
    this.singleInvestment,
    this.allInvestments,
    this.child
  });

  final List<Investments>? allInvestments;
  final Widget? child;
  final Datum? singleInvestment;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      closedColor: const Color(0xFFE5E6E8),
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 5),
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) => InvestmentHomePage(
        singleInvestment: singleInvestment!,
      ),
      // openBuilder: (_, __) => IndivisualSchemeScreen(
      //   singleScheme: singleScheme!,
      // ),
    );
  }
}
