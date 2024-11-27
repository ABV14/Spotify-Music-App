import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content.toString())));
}

Future<File?> pickAudio() async {
  try {
    final filePicker =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePicker =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
