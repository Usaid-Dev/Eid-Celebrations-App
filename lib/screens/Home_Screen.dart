import 'package:eid_celebrations_app/screens/AskEidi_Screen.dart';
import 'package:eid_celebrations_app/screens/CountDown_Screen.dart';
import 'package:eid_celebrations_app/screens/Dua_Screen.dart';
import 'package:eid_celebrations_app/screens/EidQuiz_Screen.dart';
import 'package:eid_celebrations_app/screens/EidiGenerator_Screen.dart';
import 'package:eid_celebrations_app/screens/FunnyWishes_Screen.dart';
import 'package:eid_celebrations_app/screens/WishCard_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _bgShiftController;
  late AnimationController _floatController;
  late AnimationController _moonTapController;
  int _tapCount = 0;

  final List<_HomeFeature> _features = [
    const _HomeFeature(
      title: "Eid Cards",
      subtitle: 'Send gorgeous Eid cards',
      icon: '💌',
      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
      screen: WishcardScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(      
       title: "Eid Jokes",
      subtitle: 'Hilarious Eid humor',
      icon: '😂',
      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      screen: FunnywishesScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(
       title: "Eidi",
      subtitle: 'How much you deserve?',
      icon: '💰',
      colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
      screen: EidigeneratorScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(
      title: "Eid Dua's",
      subtitle: 'Beautiful Eid prayers',
      icon: '🤲',
      colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
      screen: DuaScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(
       title: "Next Eid",
      subtitle: 'Days till next Eid',
      icon: '⏳',
      colors: [Color(0xFFffd89b), Color(0xFF19547b)],
      screen: CountdownScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(
      title: "Eid Quiz",
      subtitle: 'Test your Eid knowledge!',
      icon: '🧠',
      colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
      screen: EidquizScreen(),
      textColor: Colors.black,
    ),
    const _HomeFeature(
     title: "Ask Eidi",
     subtitle: 'Request Eidi like a pro 😇',
     icon: '💸',
     colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
     screen: AskeidiScreen(),
     textColor: Colors.black,
),
  ];

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _bgShiftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _moonTapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Auto confetti on load
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bgShiftController.dispose();
    _floatController.dispose();
    _moonTapController.dispose();
    super.dispose();
  }

  void _onMoonTap() {
    HapticFeedback.mediumImpact();
    _moonTapController.forward().then((_) => _moonTapController.reverse());
    setState(() => _tapCount++);
    if (_tapCount % 5 == 0) {
      _confettiController.play();
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Shifting gradient background
          AnimatedBuilder(
            animation: _bgShiftController,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xFF1a0533),
                      const Color(0xFF0d2137),
                      _bgShiftController.value,
                    )!,
                    Color.lerp(
                      const Color(0xFF0d2137),
                      const Color(0xFF1a0533),
                      _bgShiftController.value,
                    )!,
                    Color.lerp(
                      const Color(0xFF2d0b4e),
                      const Color(0xFF0f3d2e),
                      _bgShiftController.value,
                    )!,
                  ],
                ),
              ),
            ),
          ),

          // ✨ Twinkling stars
          ...List.generate(45, (i) => _buildStar(i, size)),

          // 🏮 Left lantern
          Positioned(
            top: 0,
            left: 10,
            child: _buildLantern(
              Colors.red.shade700,
              phaseOffset: 0,
            ),
          ),

          // 🏮 Right lantern
          Positioned(
            top: 0,
            right: 10,
            child: _buildLantern(
              Colors.amber.shade700,
              phaseOffset: math.pi,
            ),
          ),

          // 🎊 Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.08,
              numberOfParticles: 22,
              gravity: 0.3,
              colors: const [
                Colors.amber,
                Colors.pink,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),

          // Scrollable content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildMoon()),
                SliverToBoxAdapter(child: _buildTapHint()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _buildFeatureCard(_features[i], i),
                      childCount: _features.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildFunnyQuote()),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '✨  Special Edition 2026',
              style: TextStyle(
                fontSize: 11,
                color: Colors.amber,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'عيد مبارك',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 2,
              shadows: [Shadow(color: Colors.orange, blurRadius: 15)],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.2, end: 0),
          const Text(
            'Eid Mubarak 🌙',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.2, end: 0),
        ],
      ),
    );
  }

  // ── INTERACTIVE MOON ─────────────────────────────────────
  Widget _buildMoon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: GestureDetector(
          onTap: _onMoonTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_floatController, _moonTapController]),
            builder: (_, __) {
              final floatY =
                  math.sin(_floatController.value * 2 * math.pi) * 12;
              final tapScale = 1.0 - (_moonTapController.value * 0.12);
              return Transform.translate(
                offset: Offset(0, floatY),
                child: Transform.scale(
                  scale: tapScale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow rings
                      ...List.generate(3, (i) {
                        return Container(
                          width: 120.0 + (i * 32),
                          height: 120.0 + (i * 32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.withOpacity(
                                0.15 - (i * 0.04),
                              ),
                              width: 1,
                            ),
                          ),
                        );
                      }),

                      // Moon body
                      Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            center: Alignment(-0.3, -0.3),
                            colors: [
                              Color(0xFFFFF9C4),
                              Color(0xFFFFD54F),
                              Color(0xFFFFA000),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.55),
                              blurRadius: 35,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _tapCount == 0
                              ? const Icon(
                                  Icons.nightlight_round,
                                  size: 58,
                                  color: Color(0xFFFFF8E1),
                                )
                              : Text(
                                  _tapCount >= 5 ? '🎊' : '✨',
                                  style: const TextStyle(fontSize: 42),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── TAP HINT ─────────────────────────────────────────────
  Widget _buildTapHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.12),
            Colors.orange.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Text('👆', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _tapCount == 0
                  ? 'Tap the moon for a surprise!'
                  : _tapCount < 5
                      ? 'Keep tapping... $_tapCount/5 ✨'
                      : '🎊 $_tapCount taps! You\'re unstoppable!',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_tapCount >= 5)
            const Text(
              '🔥',
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  // ── FEATURE CARD ─────────────────────────────────────────
  Widget _buildFeatureCard(_HomeFeature feature, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) => feature.screen,
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: anim,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(opacity: anim, child: child),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: feature.colors,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: feature.colors[0].withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background circle decoration
            Positioned(
              right: -25,
              bottom: -25,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              left: -30,
              top: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon box
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        feature.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),

                  // Text content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with strong contrast
                      Text(
                        feature.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: feature.textColor,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Subtitle with strong contrast
                      Text(
                        feature.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: feature.textColor.withOpacity(0.85),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 1.5,
                              offset: const Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Open button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.28),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Open →',
                          style: TextStyle(
                            fontSize: 12,
                            color: feature.textColor,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 100 * index))
          .fadeIn(duration: 500.ms)
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            curve: Curves.elasticOut,
          ),
    );
  }

  // ── FUNNY QUOTE ──────────────────────────────────────────
  Widget _buildFunnyQuote() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Column(
        children: [
          Text('🌟', style: TextStyle(fontSize: 30)),
          SizedBox(height: 10),
          Text(
            '"May this Eid bring you so much joy\nthat your relatives forget to ask about\nyour marriage and career! 😂"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white60,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '— Eid Wisdom 🕌',
            style: TextStyle(
              fontSize: 12,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  // ── LANTERN ──────────────────────────────────────────────
  Widget _buildLantern(Color color, {required double phaseOffset}) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, __) {
        final sway =
            math.sin(_floatController.value * 2 * math.pi + phaseOffset) * 6;
        return Transform.translate(
          offset: Offset(sway, 0),
          child: SizedBox(
            width: 50,
            height: 120,
            child: Column(
              children: [
                Container(width: 1, height: 40, color: Colors.white30),
                Container(
                  width: 30,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.8),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 14,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── STAR ──────────────────────────────────────────────
  Widget _buildStar(int i, Size size) {
    final r = math.Random(i * 42);
    return Positioned(
      left: r.nextDouble() * size.width,
      top: r.nextDouble() * size.height * 0.6,
      child: Container(
        width: r.nextDouble() * 2 + 1,
        height: r.nextDouble() * 2 + 1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(r.nextDouble() * 0.5 + 0.2),
        ),
      )
          .animate(
            onPlay: (c) => c.repeat(reverse: true),
            delay: Duration(milliseconds: r.nextInt(2000)),
          )
          .fadeIn(
            duration: Duration(milliseconds: 800 + r.nextInt(1200)),
          ),
    );
  }
}

// ── MODEL ─────────────────────────────────────────────────
class _HomeFeature {
  final String title;
  final String subtitle;
  final String icon;
  final List<Color> colors;
  final Widget screen;
  final Color textColor;

  const _HomeFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.screen,
    required this.textColor,
  });
}
