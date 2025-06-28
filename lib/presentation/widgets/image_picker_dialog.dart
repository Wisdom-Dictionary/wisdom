import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(XFile? file) onSelected;

  const ImagePickerDialog({
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo),
          title: const Text('Gallery'),
          onTap: () async {
            await pickImage(ImageSource.gallery).then((value) => Navigator.pop(context));
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text('Camera'),
          onTap: () async {
            await pickImage(ImageSource.camera).then((value) => Navigator.pop(context));
          },
        ),
      ],
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
      );
      if (image == null) return;
      onSelected(image);
    } catch (e) {
      log('$e');
    }
  }
}
