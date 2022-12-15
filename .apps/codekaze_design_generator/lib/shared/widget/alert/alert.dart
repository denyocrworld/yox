import 'package:flutter/material.dart';

class ExAlert extends StatelessWidget {
  final String message;
  final Color color;

  ExAlert({
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Text(
          "$message",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
