import 'package:design_generator/core.dart';
import 'package:flutter/material.dart';


class ExRadio extends StatefulWidget {
  final String id;
  final String label;
  final String value;
  final List<Map<String, dynamic>> items;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool wrapped;

  ExRadio({
    this.id,
    this.label,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.items = const [],
    this.wrapped = false,
  });

  @override
  _ExRadioState createState() => _ExRadioState();
}

class _ExRadioState extends State<ExRadio> {
  String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    if (widget.value == null) {
      selectedValue = widget.items[0]["value"];
      Input.set(widget.id, selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.wrapped) {
      return Container(
        child: Container(
          padding: EdgeInsets.all(10.0),
          // height: 80.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
              Wrap(
                  children: List.generate(widget.items.length, (index) {
                var item = widget.items[index];
                bool selected = selectedValue == item["value"];

                return InkWell(
                  onTap: () {
                    selectedValue = item["value"];
                    setState(() {});
                    if (widget.onChanged != null)
                      widget.onChanged(selectedValue);
                    Input.set(widget.id, selectedValue);
                  },
                  child: Container(
                    width: Get.width / 4,
                    // width: 100.0,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    margin: EdgeInsets.only(
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    // height: theme.mediumHeight,
                    decoration: BoxDecoration(
                      borderRadius: theme.largeRadius,
                      color: selected ? theme.mainColor : theme.disabled,
                    ),
                    child: Center(
                        child: Text(
                      "${item["value"]}",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: selected ? Colors.white : theme.textColor,
                      ),
                    )),
                  ),
                );
              })),
            ],
          ),
        ),
      );
    }

    return Container(
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var item = widget.items[index];
                  bool selected = selectedValue == item["value"];

                  return InkWell(
                    onTap: () {
                      selectedValue = item["value"].toString();
                      setState(() {});
                      if (widget.onChanged != null)
                        widget.onChanged(selectedValue);
                      Input.set(widget.id, selectedValue);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                      height: theme.mediumHeight,
                      decoration: BoxDecoration(
                        borderRadius: theme.largeRadius,
                        color: selected ? theme.mainColor : theme.disabled,
                      ),
                      child: Center(
                          child: Text(
                        "${item["value"]}",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : theme.textColor,
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
