import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontFamily = GoogleFonts.roboto();

class ApplicationTheme {
  Color get mainColor {
    return Color(0xff306BDD);
  }

  Color get backgroundColor {
    return Color(0xffF8F9FA);
  }

  Color get appBarColor {
    return Colors.white;
  }

  Color get textColor {
    return Colors.grey[800];
  }

  Color get inactiveColor {
    return Colors.grey[600];
  }

  Color get success {
    return Color(0xff1AB0B0);
  }

  Color get danger {
    return Color(0xffFA5A7D);
  }

  Color get warning {
    return Color(0xffFF7443);
  }

  Color get info {
    return Color(0xff988CFC);
  }

  Color get primary {
    return Color(0xff306BDD);
  }

  Color get disabled {
    return Colors.grey[300];
  }

  //Radius
  double smallCircularRadius = 8.0;
  double mediumCircularRadius = 16.0;
  double largeCircularRadius = 32.0;

  BorderRadiusGeometry get smallRadius {
    return BorderRadius.all(Radius.circular(smallCircularRadius));
  }

  BorderRadiusGeometry get mediumRadius {
    return BorderRadius.all(Radius.circular(mediumCircularRadius));
  }

  BorderRadiusGeometry get largeRadius {
    return BorderRadius.all(Radius.circular(largeCircularRadius));
  }

  //Height
  double get smallHeight {
    return 48;
  }

  double get mediumHeight {
    return 52;
  }

  double get largeHeight {
    return 56;
  }

  //Shadow
  normalShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 6.0,
        spreadRadius: 4,
      ),
    ];
  }

  //Padding
  EdgeInsetsGeometry get normalPadding {
    return EdgeInsets.all(10.0);
  }

  EdgeInsetsGeometry get mediumPadding {
    return EdgeInsets.all(16.0);
  }

  EdgeInsetsGeometry get largePadding {
    return EdgeInsets.all(20.0);
  }

  //Border
  BoxBorder get defaultBorder {
    return Border.all(
      width: 1.0,
      color: Colors.grey[300],
    );
  }
}

var theme = ApplicationTheme();
