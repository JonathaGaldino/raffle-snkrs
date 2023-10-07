import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionScreen extends StatelessWidget {
  void openLinkedin() async {
    const url = 'https://www.linkedin.com/in/jonatha-galdino-5298601b3/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(37, 67, 217, 255),
        title: Text('Instruções'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: const Color.fromARGB(136, 201, 240, 175),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Para um melhor uso do app, siga as instruções abaixo:',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 20.0),
              InstructionItem(
                  number: '1', text: 'Pesquise PNGs dos seus tênis.'),
              InstructionItem(number: '2', text: 'Adicione as imagens ao app.'),
              InstructionItem(
                  number: '3',
                  text:
                      'Para excluir uma imagem, arraste para o lado na tela de edição.'),
              SizedBox(height: 500.0),
              TextButton(
                  onPressed: openLinkedin,
                  child: const Text('Não clique aqui!'))
            ],
          ),
        ),
      ),
    );
  }
}

class InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
