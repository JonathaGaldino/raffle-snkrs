import 'package:flutter/material.dart';
import 'package:raffle_snkrs_by_me/screens/raffle_screen.dart';
import 'package:raffle_snkrs_by_me/screens/showhow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  void _goToRaffle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RaffleScreen(),
      ),
    );
  }

  void _goToShowImagesFromFirebase() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowImagesFromFirebase(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _goToShowImagesFromFirebase,
              icon: const Icon(Icons.mode_edit_outline_outlined))
        ],
        backgroundColor: const Color.fromARGB(37, 67, 217, 255),
        title: const Text('Home Screen'),
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
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //  const SizedBox(height: 50),
                //  const Text(
                //    "Home Screen",
                //    style: TextStyle(
                //      color: Colors.white,
                //      fontSize: 30,
                //      fontWeight: FontWeight.bold,
                //    ),
                //  ),
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/screen/logo1.png',
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'We who choose your on feet today!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 15, 14, 14),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                ElevatedButton.icon(
                  onPressed: _goToRaffle,
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    foregroundColor: const Color.fromARGB(255, 14, 13, 13),
                    backgroundColor: const Color.fromRGBO(201, 240, 175, 0.719),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('what you gonna use today'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
