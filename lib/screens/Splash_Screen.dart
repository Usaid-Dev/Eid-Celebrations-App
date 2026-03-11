import 'package:eid_celebrations_app/screens/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math' as math;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) => const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF11043D),
              Color(0xFF000814),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ✨ Twinkling stars
            ...List.generate(60, (i) {
              final r = math.Random(i);
              return Positioned(
                left: r.nextDouble() * size.width,
                top: r.nextDouble() * size.height,
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, __) => Opacity(
                    opacity: 0.3 +
                        (_glowController.value * 0.7) *
                            (i % 3 == 0 ? 1 : 0.5),
                    child: Container(
                      width: r.nextDouble() * 3 + 1,
                      height: r.nextDouble() * 3 + 1,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // 🌙 Orbiting stars
            Center(
              child: AnimatedBuilder(
                animation: _orbitController,
                builder: (_, __) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      ...List.generate(5, (i) {
                        final angle =
                            _orbitController.value * 2 * math.pi +
                                (i * 2 * math.pi / 5);
                        return Transform.translate(
                          offset: Offset(
                            math.cos(angle) * 110,
                            math.sin(angle) * 110,
                          ),
                          child: Icon(
                            Icons.star,
                            color: [
                              Colors.yellow,
                              Colors.orange,
                              Colors.pink,
                              Colors.lightBlue,
                              Colors.green,
                            ][i],
                            size: 14,
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing moon
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (_, __) => Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFFFFE082),
                            Color(0xFFFFA000),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(
                              0.3 + _glowController.value * 0.4,
                            ),
                            blurRadius: 40 + _glowController.value * 20,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        size: 70,
                        color: Color(0xFFFFF8E1),
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 1200.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 40),

                  const Text(
                    'عيد مبارك',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(color: Colors.orange, blurRadius: 20),
                      ],
                    ),
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 10),

                  const Text(
                    'EID MUBARAK',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                      letterSpacing: 8,
                    ),
                  ).animate(delay: 900.ms).fadeIn(duration: 800.ms),

                  const SizedBox(height: 50),

                  // Pulsing dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      )
                          .animate(
                            delay: Duration(milliseconds: 1200 + (i * 200)),
                          )
                          .fadeIn()
                          .then()
                          .animate(
                            onPlay: (c) => c.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.5, 1.5),
                          );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
