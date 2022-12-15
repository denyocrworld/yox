import 'package:design_generator/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ExCheckBox extends StatefulWidget {
  final String id;
  final String label;
  final bool value;
  final Function(bool value) onValueChanged;

  ExCheckBox({
    this.id,
    this.label,
    this.value,
    this.onValueChanged,
  });

  @override
  ExCheckBoxState createState() => ExCheckBoxState();
}

class ExCheckBoxState extends State<ExCheckBox> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selected = selected ? false : true;
        setState(() {});

        widget.onValueChanged(selected);
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: selected ? theme.success : Colors.white,
                border: Border.all(
                  color: selected ? Colors.white : Colors.grey[300],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              child: selected != true
                  ? null
                  : Icon(
                      FlutterIcons.check_ant,
                      size: 16.0,
                      color: Colors.white,
                    ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "${widget.label}",
            style: TextStyle(
              decoration:
                  selected ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          Spacer(),
          Icon(FlutterIcons.drag_handle_mdi),
        ],
      ),
    );
  }
}
