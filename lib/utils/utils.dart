import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

Future<File?> pickImage(BuildContext context) async {
  bool? isCamera = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Camera")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Gallery")),
        ],
      ),
    ),
  );

  if (isCamera == null) {
    return null;
  }

  File? image;
  try {
    final pickedImage = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}
