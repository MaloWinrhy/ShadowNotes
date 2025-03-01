import 'package:flutter/material.dart';
import 'package:shadow_notes/src/home/views/home_view.dart';
import 'package:shadow_notes/src/home/views/notes_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupNameView extends StatefulWidget {
  const SetupNameView({super.key});

  @override
  State<SetupNameView> createState() => _SetupNameViewState();
}

class _SetupNameViewState extends State<SetupNameView> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveNameAndGoHome() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name!")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeContainer()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // centre pile la colonne
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hey, I'm ShadowNote 👋\nAnd you are...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _nameController,
                      cursorColor: Colors.green,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "pseudo",
                        hintStyle: const TextStyle(color: Colors.white38),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveNameAndGoHome,
                child: const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}