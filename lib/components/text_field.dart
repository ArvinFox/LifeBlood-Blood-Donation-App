import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputBox extends StatelessWidget {
  final String textName;
  final String hintText;
  final TextEditingController controller;
  final bool hasAstricks;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final int? multiLines;
  final int? minLines;

  const CustomInputBox({
    super.key,
    required this.textName,
    required this.hintText,
    required this.controller,
    this.hasAstricks = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator, 
    this.multiLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: controller,
          obscureText: hasAstricks, //for hide password in password fields
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          // maxLines: multiLines,
          // minLines: minLines,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
