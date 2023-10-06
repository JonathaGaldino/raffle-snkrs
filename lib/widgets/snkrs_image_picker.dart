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
import 'package:fluttertoast/fluttertoast.dart';
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

  bool _isUploading = false;

  Future<void> _uploadImages() async {
    setState(() {
      _isUploading =
          true; // Defina como verdadeiro para indicar que o upload está em andamento
    });

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
          _showToast('Imagem carregada com sucesso', true);
        }
      } on FirebaseException catch (e) {
        print('Erro ao carregar a imagem: $e');
        _showToast('Erro ao carregar a imagem: $e', false);
      }
    }

    // Limpe a lista de imagens após o upload
    setState(() {
      imageFiles.clear();
    });

    Navigator.pop(context);

    setState(() {
      _isUploading =
          false; // Defina como falso para indicar que o upload está completo
    });
  }

  void _showToast(String message, bool success) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:
          success ? const Color.fromRGBO(201, 240, 175, 0.719) : Colors.red,
      textColor: Colors.white,
    );
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
          onPressed: _isUploading || imageFiles.isEmpty
              ? null
              : () {
                  _uploadImages();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: imageFiles.isNotEmpty
                ? const Color.fromARGB(131, 144, 177, 233)
                : Colors.grey, // Cor do botão dependendo do estado
          ),
          child: const Text('Upload Images'),
        )
      ],
    );
  }
}
