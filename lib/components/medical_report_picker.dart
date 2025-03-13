import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MedicalReportPicker extends StatefulWidget {
  final Function(String)? onFileUploaded;

  const MedicalReportPicker({super.key, this.onFileUploaded});

  @override
  State<MedicalReportPicker> createState() => _MedicalReportPickerState();
}

class _MedicalReportPickerState extends State<MedicalReportPicker> {
  String text = 'Select Medical Report';
  Color btnColor = Colors.white;

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result != null) {
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      if (filePath != null) {
        try {
          final fileBytes = await File(filePath).readAsBytes();
          String base64String = base64Encode(fileBytes);

          setState(() {
            text = fileName.length > 20
                ? "${fileName.substring(0, 20)}...."
                : fileName;
            btnColor = Colors.red;
          });

          if (widget.onFileUploaded != null) {
            widget.onFileUploaded!(base64String); 
          }
        } catch (e) {
          print('Error while reading or encoding the file: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: uploadFile,
        style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black38))),
        child: Text(
          text,
          style: TextStyle(
              color: btnColor == Colors.red ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
