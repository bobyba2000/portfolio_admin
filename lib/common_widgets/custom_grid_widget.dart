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
    int count = 0;
    List<Widget> rowChildren = [];
    for (var child in widget.children) {
      rowChildren.add(Expanded(child: child));
      count++;
      if (count % 3 == 0) {
        children.add(Row(
          children: rowChildren,
        ));
        children.add(const SizedBox(height: 24));
        rowChildren = [];
      } else {
        rowChildren.add(const SizedBox(width: 24));
      }
    }
    if (rowChildren.isNotEmpty) {
      while (count % 3 != 0) {
        rowChildren.add(Expanded(child: Container()));
        count++;
        if (count % 3 != 0) {
          rowChildren.add(const SizedBox(width: 24));
        }
      }
      children.add(Row(
        children: rowChildren,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
