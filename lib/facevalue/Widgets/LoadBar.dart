import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TWO_PI = 3.14 * 2;

class LoadBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = 200.0;
    return Scaffold(
      body: Center(
        child: Container(
          width: size,
          height: size,
          child: Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return SweepGradient(
                      startAngle: 0.0,
                      endAngle: TWO_PI,
                      // stops: [0.7, 0.7],
                      // 0.0 , 0.5 , 0.5 , 1.0
                      center: Alignment.center,
                      colors: [Colors.blue, Colors.transparent])
                      .createShader(rect);
                },
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}