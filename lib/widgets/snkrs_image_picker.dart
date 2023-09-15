/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SnkrsImagePicker extends StatefulWidget {
  const SnkrsImagePicker({super.key});

  @override
  State<SnkrsImagePicker> createState() {
    return _SnkrsImagePickerState();
  }
}

class _SnkrsImagePickerState extends State<SnkrsImagePicker> {
  void _pickerImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _pickerImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SnkrsImagePicker extends StatefulWidget {
  final void Function(String) onImageUploaded;

  SnkrsImagePicker({required this.onImageUploaded, Key? key}) : super(key: key);

  @override
  _SnkrsImagePickerState createState() => _SnkrsImagePickerState();
}

class _SnkrsImagePickerState extends State<SnkrsImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<File> imageFiles = [];

  Future<void> _pickerImage() async {
    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    final imageFile = File(pickedImage.path);

    setState(() {
      imageFiles.add(imageFile);
    });
  }

  Future<void> _uploadImages() async {
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('snkrs_images');

    for (final imageFile in imageFiles) {
      final uniqueFileName = Uuid().v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final fileName = 'snkrs_${timestamp}_$uniqueFileName.png';

      try {
        final Reference imageRef = storageRef.child(fileName);
        final TaskSnapshot snapshot = await imageRef.putFile(imageFile);
        print('Imagem carregada com sucesso.');

        if (snapshot.state == TaskState.success) {
          final String imageUrl = await snapshot.ref.getDownloadURL();
          widget.onImageUploaded(imageUrl);
        }
      } on FirebaseException catch (e) {
        print('Erro ao carregar a imagem: $e');
      }
    }

    // Limpe a lista de imagens após o upload
    setState(() {
      imageFiles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _pickerImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: imageFiles.isNotEmpty ? _uploadImages : null,
          child: Text('Upload Images'),
        ),
      ],
    );
  }
}
