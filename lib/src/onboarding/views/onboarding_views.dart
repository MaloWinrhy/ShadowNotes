import 'package:flutter/material.dart';
import 'package:shadow_notes/src/onboarding/controllers/onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController();

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: ValueListenableBuilder<int>(
        valueListenable: controller.currentPage,
        builder: (context, currentPage, _) {
          return Stack(
            children: [
              PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingData.length,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemBuilder: (context, index) {
                  final data = controller.onboardingData[index];
                  return _OnboardingPage(
                    title: data['title']!,
                    description: data['description']!,
                    icon: data['icon']!,
                    isLastPage: index == controller.onboardingData.length - 1,
                    onDonateTap: controller.openBuyMeACoffee,
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildBottomBar(context, controller, currentPage),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, OnboardingController controller, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => controller.completeOnboarding(context),
          child: const Text('Skip', style: TextStyle(color: Colors.white70)),
        ),
        Row(
          children: List.generate(controller.onboardingData.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.green : Colors.grey,
              ),
            );
          }),
        ),
        TextButton(
          onPressed: () => controller.nextPage(context),
          child: Text(
            currentPage == controller.onboardingData.length - 1 ? 'Finish' : 'Next',
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
  final bool isLastPage;
  final VoidCallback? onDonateTap;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    this.isLastPage = false,
    this.onDonateTap,
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
         if (isLastPage) ...[
  const SizedBox(height: 20),
  OutlinedButton.icon(
    onPressed: onDonateTap,
    icon: const Icon(Icons.favorite, color: Colors.white),
    label: const Text(
      'Support',
      style: TextStyle(color: Colors.white),
    ),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.pink),
      foregroundColor: Colors.pink,
      backgroundColor: Colors.pink,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
]
        ],
      ),
    );
  }
}