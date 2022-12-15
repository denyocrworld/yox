import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class FeatureBox extends StatelessWidget {
  final String label;
  final IconData icon;

  final double width;
  final double height;

  FeatureBox({
    this.label,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: width,
      width: height,
      blur: 1,
      opacity: 0.3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 46.0,
              color: Colors.white,
            ),
            Spacer(),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
