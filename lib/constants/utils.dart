import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];

  try {
    var filesWrapper = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (filesWrapper != null && filesWrapper.files.isNotEmpty) {
      for (int i = 0; i < filesWrapper.files.length; i++) {
        images.add(File(filesWrapper.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return images;
}
