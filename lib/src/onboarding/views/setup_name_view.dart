import 'package:flutter/material.dart';
import 'package:shadow_notes/src/onboarding/controllers/setup_name_controller.dart';

class SetupNameView extends StatelessWidget {
  const SetupNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SetupNameController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: controller.nameController,
                      cursorColor: Colors.green,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Your pseudo...",
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
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => controller.saveNameAndGoHome(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}