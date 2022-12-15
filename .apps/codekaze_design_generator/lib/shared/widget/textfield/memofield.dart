import 'package:design_generator/core.dart';
import 'package:flutter/material.dart';

class ExMemoField extends StatelessWidget {
  final String id;
  final String value;
  final String label;

  ExMemoField({
    @required this.id,
    @required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ExTextField(
      id: "$id",
      label: "$label",
      value: value,
      height: 200,
      keyboardType: TextInputType.multiline,
    );
  }
}
