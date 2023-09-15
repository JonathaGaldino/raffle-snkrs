import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreen();
  }
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(37, 67, 217, 255),
        title: const Text('Edit Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 144, 176, 233),
              Color.fromARGB(255, 144, 176, 233),
              Color.fromARGB(255, 201, 240, 175),
            ],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 201, 240, 175),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.photo_camera),
                  label: const Text(
                    'Choose your sneaker from gallery',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 201, 240, 175),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    'Delete any sneakers',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 201, 240, 175),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.feed_outlined),
                  label: const Text(
                    'Check your entired list',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  child: Image.asset(
                    'assets/screen/logo1.png',
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
