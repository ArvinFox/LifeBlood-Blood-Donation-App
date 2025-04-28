import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputBox extends StatefulWidget {
  final String textName;
  final String hintText;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController controller;
  final bool hasAstricks;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final int? multiLines;
  final int? minLines;
  final bool NoneedToEdit;
  final Function(String)? onChanged;

  const CustomInputBox({
    super.key,
    required this.textName,
    this.autovalidateMode,
    required this.hintText,
    required this.controller,
    this.hasAstricks = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.multiLines,
    this.minLines,
    this.NoneedToEdit = false,
    this.onChanged,
  });

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.hasAstricks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.textName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.hasAstricks ? _obscureText : false, // Password visibility
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.NoneedToEdit,
          onChanged: widget.onChanged,
          autovalidateMode: widget.autovalidateMode,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: widget.NoneedToEdit ? Colors.transparent : Colors.white, // Set background color
            suffixIcon: widget.hasAstricks
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
