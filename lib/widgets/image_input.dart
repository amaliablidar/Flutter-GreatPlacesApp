import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      if (imageFile != null) {
        _storedImage = File(imageFile.path);
      }
    });
    if (imageFile != null) {
      final Directory appDir =
          await syspaths.getApplicationDocumentsDirectory();
      final String fileName = path.basename(imageFile.path);
      final File savedImage =
          await File(imageFile.path).copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage == null
              ? Text(
                  'No image taken',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            label: Text('Choose a picture'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.indigo)),
            icon: Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }
}
