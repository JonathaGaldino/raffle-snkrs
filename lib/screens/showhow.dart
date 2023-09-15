import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/snkrs_image_picker.dart';

class ShowImagesFromFirebase extends StatefulWidget {
  @override
  _ShowImagesFromFirebaseState createState() => _ShowImagesFromFirebaseState();
}

class _ShowImagesFromFirebaseState extends State<ShowImagesFromFirebase> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    loadFirebaseImages();
  }

  Future<void> loadFirebaseImages() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('snkrs_images');

    try {
      final ListResult result = await ref.listAll();

      setState(() {
        imageUrls = result.items.map((item) {
          // Construa a URL HTTP válida a partir do caminho do Firebase Storage
          final gsUrl = item.fullPath;
          final httpUrl = gsUrl.replaceFirst(
              'gs://raffle-snkrs-by-me.appspot.com/',
              'https://storage.googleapis.com/raffle-snkrs-by-me.appspot.com/');
          return httpUrl;
        }).toList();
      });
    } catch (error) {
      print('Erro ao carregar imagens do Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(37, 67, 217, 255),
        title: Text('Edit Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];

                return Container(
                  height: 100,
                  width: double.infinity,
                  color: index % 2 == 0
                      ? const Color.fromARGB(131, 144, 177, 233)
                      : const Color.fromARGB(136, 201, 240, 175),
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedImageUrl = await showModalBottomSheet<String>(
            context: context,
            builder: (BuildContext context) {
              return SnkrsImagePicker(
                onImageUploaded: (imageUrl) {
                  setState(() {
                    imageUrls.add(imageUrl);
                  });
                },
              );
            },
          );
        },
        backgroundColor: const Color.fromARGB(171, 4, 245, 193),
        heroTag: null,
        elevation: 6.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
