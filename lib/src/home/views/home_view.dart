import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shadow_notes/src/home/views/notes_view.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    NotesView(),
    NotesView(),
    NotesView(),
    NotesView(),
  ];

  late AnimationController _waveController;

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
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Permet aux vagues de déborder
        children: [
          Positioned(
            bottom: 95, // Ce qui fait que ça sort de la nav bar vers le haut
            left: 0,
            right: 0,
            height: 60, // Hauteur totale des vagues
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: WavePainter(
                        progress: _waveController.value,
                        amplitude: 20,
                        speedFactor: 1.0,
                        color: Colors.green.withOpacity(0.4),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: WavePainter(
                        progress: _waveController.value,
                        amplitude: 14,
                        speedFactor: 1.8,
                        color: Colors.green.withOpacity(0.6),
                        phaseShift: pi / 2,
                      ),
                    ),
                    CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: WavePainter(
                        progress: _waveController.value,
                        amplitude: 10,
                        speedFactor: 2.5,
                        color: Colors.green.withOpacity(0.8),
                        phaseShift: pi,
                      ),
                    ),
                    CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: WavePainter(
                        progress: _waveController.value,
                        amplitude: 6,
                        speedFactor: 2.5,
                        color: Colors.green.withOpacity(1),
                        phaseShift: pi,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
           WaterDropNavBar(
            backgroundColor: Colors.black,
            waterDropColor: Colors.green,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
            },
            selectedIndex: _currentIndex,
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
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final double amplitude;
  final double speedFactor;
  final Color color;
  final double phaseShift;

  WavePainter({
    required this.progress,
    required this.amplitude,
    required this.speedFactor,
    required this.color,
    this.phaseShift = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    final double waveOffset = progress * 2 * pi;

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - (amplitude * sin((x / size.width * 2 * pi * speedFactor) + waveOffset + phaseShift));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}