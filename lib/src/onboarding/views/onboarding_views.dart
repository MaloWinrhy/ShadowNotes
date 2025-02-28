import 'package:flutter/material.dart';
import 'package:shadow_notes/src/onboarding/views/setup_name_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Welcome to ShadowNotes',
      'description': 'Your notes, protected and encrypted.',
      'icon': LucideIcons.fileLock,
    },
    {
      'title': 'Each note has its password',
      'description': 'Secure each note individually.',
      'icon': LucideIcons.key,
    },
    {
      'title': 'QR Code Sharing',
      'description': 'Send your encrypted notes securely.',
      'icon': LucideIcons.scanLine,
    },
    {
      'title': 'Panic Mode',
      'description': 'Reveals a fake note in case of emergency.',
      'icon': LucideIcons.alertTriangle,
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetupNameView()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage == onboardingData.length - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return _OnboardingPage(
                title: data['title']!,
                description: data['description']!,
                icon: data['icon']!,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _completeOnboarding,
          child: const Text('Skip', style: TextStyle(color: Colors.white70)),
        ),
        Row(
          children: List.generate(onboardingData.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.green : Colors.grey,
              ),
            );
          }),
        ),
        TextButton(
          onPressed: _nextPage,
          child: Text(
            _currentPage == onboardingData.length - 1 ? 'Finish' : 'Next',
            style: const TextStyle(color: Colors.green),
          ),
        )
      ],
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.green),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}