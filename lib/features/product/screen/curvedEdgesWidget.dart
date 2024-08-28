import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/customCurvedEdges.dart';

class CurvedEdgesWidget extends StatelessWidget{
  const CurvedEdgesWidget({super.key,required this.child,});
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return ClipPath(  
      clipper: U_CustomCurvedEdges(),
      child: child,
    );
  }


}