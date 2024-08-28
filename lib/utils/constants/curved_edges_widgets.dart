import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/customCurvedEdges.dart';

class U_CurvedEdgesWidget extends StatelessWidget {
  const U_CurvedEdgesWidget({
    super.key, this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: U_CustomCurvedEdges(),
      child: child
    );
  }
}



