import 'package:design_generator/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

Map<String, ExDatePickerState> datePickerInstance = {};

DateTime firstBlankDate = DateTime(1900, 1, 1);
DateTime lastBlankDate = DateTime(3000, 1, 1);

class ExDatePicker extends StatefulWidget {
  final String id;
  final String label;
  final DateTime value;
  final Function(DateTime value) onChanged;

  ExDatePicker({
    @required this.id,
    this.label,
    this.value,
    this.onChanged,
  });

  @override
  ExDatePickerState createState() => ExDatePickerState();
}

class ExDatePickerState extends State<ExDatePicker> {
  DateTime value;

  @override
  void initState() {
    super.initState();
    // value = widget.value ?? DateTime.now();
    value = widget.value;
    Input.set(widget.id, value);
    datePickerInstance[widget.id] = this;
  }

  String get formattedValue {
    if (value == null) return "-- select date --";
    return DateFormat("d MMM y").format(value);
  }

  resetValue() {
    value = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              right: 4.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Text("${widget.label}"),
          ),
          InkWell(
            onTap: () async {
              var selectedDay = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: MaterialColor(
                        theme.mainColor.value,
                        <int, Color>{
                          50: theme.mainColor,
                          100: theme.mainColor,
                          200: theme.mainColor,
                          300: theme.mainColor,
                          400: theme.mainColor,
                          500: theme.mainColor,
                          600: theme.mainColor,
                          700: theme.mainColor,
                          800: theme.mainColor,
                          900: theme.mainColor,
                        },
                      ),
                    ), // This will change to light theme.
                    child: child,
                  );
                },
              );

              if (selectedDay == null) return;

              setState(() {
                value = selectedDay;
                Input.set(widget.id, value);

                if (widget.onChanged != null) widget.onChanged(value);
              });
            },
            child: Container(
              height: 38.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[400],
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                children: [
                  Text("$formattedValue"),
                  Spacer(),
                  Icon(
                    FontAwesomeIcons.calendarWeek,
                    color: Colors.grey[500],
                    size: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
