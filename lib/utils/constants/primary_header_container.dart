import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/circular_container.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/curved_edges_widgets.dart';

class U_ProductPrimaryHeaderContainer extends StatelessWidget {
  const U_ProductPrimaryHeaderContainer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return U_CurvedEdgesWidget(
      child: SizedBox(
        height: 350,
        child: Container(
          color: U_Colors.chatprimaryColor,
         // padding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              Positioned(
                  top: -150,
                  right: -250,
                  child: CircularContainer(
                    backgroundColor: U_Colors.whiteColor.withOpacity(0.1),
                  )),
              Positioned(
                  top: 100,
                  right: -300,
                  child: CircularContainer(
                    backgroundColor: U_Colors.whiteColor.withOpacity(0.1),
                  )),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
