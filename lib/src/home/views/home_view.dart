import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shadow_notes/src/home/controllers/home_controller.dart';
import 'package:shadow_notes/src/home/widgets/wave_painter.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> with SingleTickerProviderStateMixin {
  final controller = HomeController();
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: controller.pages[currentIndex],
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                height: 60,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        WavePainterWidget(_waveController.value, 20, 1.0, Colors.green.withOpacity(0.4)),
                        WavePainterWidget(_waveController.value, 14, 1.8, Colors.green.withOpacity(0.6), pi / 2),
                        WavePainterWidget(_waveController.value, 10, 2.5, Colors.green.withOpacity(0.8), pi),
                        WavePainterWidget(_waveController.value, 6, 2.5, Colors.green.withOpacity(1), pi),
                      ],
                    );
                  },
                ),
              ),
              WaterDropNavBar(
                bottomPadding: 10,
                backgroundColor: Colors.black,
                waterDropColor: Colors.green,
                onItemSelected: (index) => controller.changePage(context, index),
                selectedIndex: currentIndex,
                barItems: [
                  BarItem(filledIcon: Icons.notes, outlinedIcon: Icons.notes_outlined),
                  BarItem(filledIcon: Icons.lock, outlinedIcon: Icons.lock_outline),
                  BarItem(filledIcon: Icons.qr_code, outlinedIcon: Icons.qr_code_outlined),
                  BarItem(filledIcon: Icons.settings, outlinedIcon: Icons.settings_outlined),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class WavePainterWidget extends StatelessWidget {
  final double progress;
  final double amplitude;
  final double speedFactor;
  final Color color;
  final double phaseShift;

  const WavePainterWidget(
    this.progress,
    this.amplitude,
    this.speedFactor,
    this.color, [
    this.phaseShift = 0,
  ]);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: WavePainter(
        progress: progress,
        amplitude: amplitude,
        speedFactor: speedFactor,
        color: color,
        phaseShift: phaseShift,
      ),
    );
  }
}