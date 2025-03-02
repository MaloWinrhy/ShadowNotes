import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../onboarding/views/setup_name_view.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingController {
  final PageController pageController = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier(0);

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Welcome to ShadowNotes',
      'description': 'Your notes, protected and encrypted.',
      'icon': Icons.lock_outline,
    },
    {
      'title': 'Each note has its password',
      'description': 'Secure each note individually.',
      'icon': Icons.vpn_key,
    },
    {
      'title': 'QR Code Sharing',
      'description': 'Send your encrypted notes securely.',
      'icon': Icons.qr_code,
    },
    {
      'title': 'Panic Mode',
      'description': 'Reveals a fake note in case of emergency.',
      'icon': Icons.warning_amber,
    },
    {
      'title': 'Support Development',
      'description': 'Buy me a coffee to support this project!',
      'icon': Icons.favorite,
    },
  ];

  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetupNameView()),
    );
  }

  void nextPage(BuildContext context) {
    if (currentPage.value == onboardingData.length - 1) {
      completeOnboarding(context);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  Future<void> openBuyMeACoffee() async {
    const url = 'https://buymeacoffee.com/winrhy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not open $url');
    }
  }
}