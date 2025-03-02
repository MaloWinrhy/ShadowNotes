import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shadow_notes/src/splash/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SplashController(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/lottie/shadownotes_loading.json', width: 400, height: 400),
          ),
          Positioned(
            bottom: 20,
            child: ValueListenableBuilder<String>(
              valueListenable: controller.appVersion,
              builder: (_, version, __) {
                return Text(version, style: const TextStyle(color: Colors.green, fontSize: 14));
              },
            ),
          ),
        ],
      ),
    );
  }
}