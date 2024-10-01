import 'package:flutter/material.dart';

class DividerWithAvatar extends StatelessWidget {

  final String imagePath;
  final double avatarRadius;
  final Color dividerColor;
  final double dividerThickness;

  const DividerWithAvatar({
    super.key,
    required this.imagePath,
    this.avatarRadius = 10.0,
    this.dividerColor = Colors.grey,
    this.dividerThickness = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor, // Divider color
            thickness: dividerThickness, // Divider thickness
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            radius: avatarRadius, // Size of the avatar
            backgroundImage: AssetImage(imagePath), // Path to your image asset
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor, // Divider color
            thickness: dividerThickness, // Divider thickness
          ),
        ),
      ],
    );
  }
}
