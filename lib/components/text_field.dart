import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputBox extends StatefulWidget {
  final String textName;
  final String hintText;
  final TextEditingController controller;
  final bool hasAstricks;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final int? multiLines;
  final int? minLines;
  final bool needToEdit;
  final Function(String)? onChanged;

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
    this.needToEdit = false,
    this.onChanged
  });

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.hasAstricks;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.hasAstricks) {
        setState(() {
          _obscureText = true; 
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode, // Attach the FocusNode
          obscureText: widget.hasAstricks ? _obscureText : false, //password visibility
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.needToEdit,
          onChanged: widget.onChanged,
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
