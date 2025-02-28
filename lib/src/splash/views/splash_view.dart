// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shadow_notes/src/home/views/home_view.dart';
import 'package:shadow_notes/src/onboarding/views/onboarding_views.dart';
import 'package:shadow_notes/src/onboarding/views/setup_name_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String appVersion = '...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _navigateNext();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'v${info.version}';
    });
  }

    Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final username = prefs.getString('username');

    if (!seenOnboarding) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingView()));
    } else if (username == null || username.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SetupNameView()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Stack(
        alignment: Alignment.center,
        children: [
         Center(child: Lottie.asset('assets/lottie/shadownotes_loading.json', width: 400, height: 400),),
          Positioned(
            bottom: 20,
            child: Text(appVersion, style: const TextStyle(color: Colors.green, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}