import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;
  final bool isPassword;
  final String label;
  final String? suffixText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.readOnly = false,
    this.hintText,
    this.isPassword = false,
    required this.label,
    this.suffixText,
    this.maxLines,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 4),
        FormBuilderTextField(
          name: '',
          controller: controller,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: maxLines ?? 1,
          readOnly: readOnly,
          maxLength: 500,
          obscureText: isPassword,
          inputFormatters: inputFormatters ?? [],
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            border: _inputBorder(Colors.transparent),
            enabledBorder: _inputBorder(Colors.transparent),
            focusedBorder: _inputBorder(Colors.black),
            errorBorder: _inputBorder(Colors.red),
            focusedErrorBorder: _inputBorder(Colors.transparent),
            disabledBorder: _inputBorder(Colors.transparent),
            counterText: '',
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(41, 35, 63, 0.5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            suffixText: suffixText,
          ),
        ),
      ],
    );
  }
}
