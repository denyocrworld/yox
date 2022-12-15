import 'package:design_generator/core.dart';
import 'package:flutter/material.dart';

class ExButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color color;
  final IconData icon;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;

  ExButton({
    @required this.label,
    @required this.onPressed,
    this.color,
    this.icon,
    this.height,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        height: height ?? theme.smallHeight,
        decoration: BoxDecoration(
          color: color ?? theme.mainColor,
          borderRadius: borderRadius ?? theme.smallRadius,
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color:
                      color == theme.disabled ? theme.textColor : Colors.white,
                  size: 28,
                ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                "$label",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      color == theme.disabled ? theme.textColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
