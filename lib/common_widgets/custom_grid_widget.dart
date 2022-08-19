import 'package:flutter/material.dart';

class CustomGridWidget extends StatefulWidget {
  final List<Widget> children;
  const CustomGridWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<CustomGridWidget> createState() => _CustomGridWidgetState();
}

class _CustomGridWidgetState extends State<CustomGridWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int count = 1;
    Row row = Row();
    for (var child in widget.children) {
      if (count % 3 == 0) {
        children.add(row);
        row = Row();
      } else {
        row.children.add(const SizedBox(width: 16));
      }
      row.children.add(Expanded(child: child));
      count++;
    }
    return Column(
      children: children,
    );
  }
}
