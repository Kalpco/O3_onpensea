import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

class SkeletonCards extends StatelessWidget {
  const SkeletonCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Skeleton(height: 210, width: 500),
        SizedBox(
          height: 5,
        ),
        Skeleton(
          height: 50,
          width: 500,
        )
      ],
    );
  }
}