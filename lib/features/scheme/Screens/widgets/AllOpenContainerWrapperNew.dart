import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/features/scheme/Screens/widgets/AllSchemeGridView.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';

class AllOpenContainerWrapperNew extends StatelessWidget {

  AllOpenContainerWrapperNew({
    super.key,
    required this.child,
    required this.allInvestments,
    required this.investmentType
  });

  final Widget child;
  List<Datum>? allInvestments;
  String? investmentType;

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
      openBuilder: (_, __) => AllSchemeGridView(
        allInvestments: allInvestments!,
        investmentType: investmentType!,
      ),
      // openBuilder: (_, __) => IndivisualSchemeScreen(
      //   singleScheme: singleScheme!,
      // ),
    );
  }
}
