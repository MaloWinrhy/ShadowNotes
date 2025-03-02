import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/views/home_view.dart';
import '../../onboarding/views/onboarding_views.dart';
import '../../onboarding/views/setup_name_view.dart';

class SplashController {
  final BuildContext context;
  final ValueNotifier<String> appVersion = ValueNotifier('...');

  SplashController(this.context);

  Future<void> init() async {
    await _loadVersion();
    await _navigateNext();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = 'v${info.version}';
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final username = prefs.getString('username');

    if (!seenOnboarding) {
      _navigateTo(const OnboardingView());
    } else if (username == null || username.isEmpty) {
      _navigateTo(const SetupNameView());
    } else {
      _navigateTo(const HomeContainer());
    }
  }

  void _navigateTo(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}