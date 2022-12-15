import 'package:flutter/material.dart';

class ActionIcon extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  final int value;

  ActionIcon({
    this.icon,
    this.onTap,
    this.value,
  });
  @override
  _ActionIconState createState() => _ActionIconState();
}

class _ActionIconState extends State<ActionIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(child: Icon(widget.icon)),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: widget.value == null
                ? Container()
                : CircleAvatar(
                    radius: 10.0,
                    child: Center(
                      child: Text(
                        "${widget.value}",
                        style: TextStyle(
                          fontSize: 8.0,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
