import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

      final futures = result.items.map((item) async {
        // Obtenha uma URL de download assinada para o item
        final downloadUrl = await item.getDownloadURL();
        return downloadUrl;
      }).toList();

      final urls = await Future.wait(futures);

      setState(() {
        imageUrls = urls;
      });
      // Exibir toast de sucesso
      showToast('Imagens carregadas com sucesso', true);
    } catch (error) {
      print('Erro ao carregar imagens do Firebase: $error');

      // Exibir toast de falha
      showToast('Erro ao carregar imagens do Firebase: $error', false);
    }
  }

  void showToast(String message, bool success) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:
          success ? const Color.fromRGBO(201, 240, 175, 0.719) : Colors.red,
      textColor: Color.fromARGB(255, 14, 13, 13),
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    final storage = FirebaseStorage.instance;

    try {
      // Crie uma referência para a imagem usando a URL
      final ref = storage.refFromURL(imageUrl);

      // Exclua a imagem do Firebase Storage
      await ref.delete();

      setState(() {
        // Remova a URL da lista de imagens após a exclusão bem-sucedida
        imageUrls.remove(imageUrl);
      });
    } catch (error) {
      print('Erro ao excluir imagem do Firebase: $error');
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

                return Dismissible(
                  key: Key(imageUrl), // Chave única para o item
                  onDismissed: (direction) {
                    // Chama a função para excluir a imagem ao deslizar
                    deleteImage(imageUrl);
                  },
                  background: Container(
                    color: Colors.red, // Cor de fundo ao deslizar para excluir
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
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
