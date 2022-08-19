import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final String text;
  final Function() onClick;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BoxBorder? border;
  const BaseButton({
    Key? key,
    required this.text,
    required this.onClick,
    this.textStyle,
    this.backgroundColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: backgroundColor,
          border: border,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
