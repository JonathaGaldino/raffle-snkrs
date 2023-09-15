/*import 'dart:math';

import 'package:flutter/material.dart';

final randomizer = Random();

class RaffleScreen extends StatefulWidget {
  const RaffleScreen({super.key});

  @override
  State<RaffleScreen> createState() {
    return _RaffleScreenState();
  }
}

class _RaffleScreenState extends State<RaffleScreen> {
  var currentSnkrsRoll = 2;
  double opacityLevel = 1.0;

  void raffleSnkr() {
    setState(() {
      currentSnkrsRoll = randomizer.nextInt(7) + 1;
      opacityLevel = 0.2;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use Scaffold para definir o fundo da tela
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(37, 67, 217, 255),
        title: const Text('Raffle Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 144, 176, 233),
              Color.fromARGB(255, 201, 240, 175),
              Color.fromARGB(255, 144, 176, 233),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'On feet for today!!',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 17, 16, 16),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(
                    milliseconds: 344,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/snkrs_$currentSnkrsRoll.png',
                        width: 200,
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: raffleSnkr,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(127, 144, 177, 233),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Raffle!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RaffleScreen extends StatefulWidget {
  const RaffleScreen({Key? key}) : super(key: key);

  @override
  State<RaffleScreen> createState() => _RaffleScreenState();
}

class _RaffleScreenState extends State<RaffleScreen> {
  String imageUrl = '';
  final Set<String> usedUuids = {}; // Conjunto para rastrear UUIDs usados
  final Random random = Random();

  Future<void> raffleSnkr() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('snkrs_images');

    final ListResult result = await ref.listAll();
    final items = result.items;

    if (items.isEmpty) {
      // Não há imagens disponíveis
      setState(() {
        imageUrl = '';
      });
      return;
    }

    String randomUuid;
    bool isNewUuid = false;

    // Continue gerando UUIDs aleatórios até encontrar um que ainda não foi usado
    do {
      final randomIndex = random.nextInt(items.length);
      final randomImage = items[randomIndex];
      randomUuid = randomImage.name;

      isNewUuid = !usedUuids.contains(randomUuid);

      // Se todas as imagens já foram usadas, limpe o conjunto de UUIDs usados
      if (usedUuids.length == items.length) {
        usedUuids.clear();
      }
    } while (!isNewUuid);

    usedUuids.add(randomUuid);

    try {
      final imageUrl = await ref.child(randomUuid).getDownloadURL();

      setState(() {
        this.imageUrl = imageUrl;
      });
    } catch (error) {
      // Lida com erros ao buscar a URL da imagem
      print('Erro ao buscar a URL da imagem: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(37, 67, 217, 255),
        title: const Text('Raffle Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 144, 176, 233),
              Color.fromARGB(255, 201, 240, 175),
              Color.fromARGB(255, 144, 176, 233),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'On feet for today!!',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 17, 16, 16),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: imageUrl.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 344),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 200,
                      )
                    : const SizedBox(), // Exibe uma imagem vazia enquanto a URL não está disponível
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: raffleSnkr,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(127, 144, 177, 233),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('Raffle!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
