import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;

class FunnywishesScreen extends StatefulWidget {
  const FunnywishesScreen({super.key});

  @override
  State<FunnywishesScreen> createState() => _FunnywishesScreenState();
}

class _FunnywishesScreenState extends State<FunnywishesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  final math.Random _rng = math.Random();
  int _currentIndex = 0;
  bool _isRevealing = false;

  final List<_FunnyWish> _jokes = const [
    _FunnyWish(
      '🍛',
      'Eid Mubarak!\nMay your biryani be perfectly spiced and your relatives\' questions be perfectly mild! 😄',
      [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    _FunnyWish(
      '⚖️',
      'Happy Eid! 🌙\nScientists confirm: calories do NOT exist on Eid. Eat as much as you want. Trust the science! 🍰',
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    _FunnyWish(
      '💵',
      'Eid Mubarak! ⭐\nMay your Eidi be crisp, your outfit be fresh, and your relatives not ask "when are you getting married?" 😅',
      [Color.fromARGB(255, 22, 114, 53), Color(0xFF38f9d7)],
    ),
    _FunnyWish(
      '🤳',
      'Happy Eid! 🎊\nMay your selfies get more likes than your relatives have opinions about your life choices! 📸',
      [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    ),
    _FunnyWish(
      '🛌',
      'Eid Mubarak! 🕌\nMay you sleep in guilt-free, eat guilt-free, and answer zero family questions guilt-free! 😴',
      [Color(0xFFffd89b), Color(0xFF19547b)],
    ),
    _FunnyWish(
      '📿',
      'Happy Eid! 🌙\nMay Allah grant you: good health, wealth, and an uncle who gives cash Eidi instead of advice! 🤲',
      [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    _FunnyWish(
      '🏃',
      'Eid Mubarak! 🎉\nMay you run faster than your relatives can ask "what\'s your GPA?" at the Eid gathering! 😂',
      [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _nextJoke() async {
    if (_isRevealing) return;
    HapticFeedback.heavyImpact();
    setState(() => _isRevealing = true);

    await _shakeCtrl.forward();
    _shakeCtrl.reset();

    setState(() {
      int newIndex;
      do {
        newIndex = _rng.nextInt(_jokes.length);
      } while (newIndex == _currentIndex);
      _currentIndex = newIndex;
      _isRevealing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final joke = _jokes[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              joke.colors[0].withOpacity(0.3),
              const Color(0xFF0d1b2a),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                    ),
                    const Text(
                      '😂 Funny Wishes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _shakeCtrl,
                    builder: (_, __) {
                      final shake =
                          math.sin(_shakeCtrl.value * math.pi * 8) * 8;
                      return Transform.translate(
                        offset: Offset(shake, 0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _buildJokeCard(joke),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _nextJoke,
                      icon: const Icon(Icons.refresh, size: 22),
                      label: const Text(
                        '😂 Next Funny Wish',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: joke.colors[0],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Share.share(
                          '${joke.text}\n\n🌙 Eid Mubarak! 🌙',
                          subject: 'Funny Eid Wish',
                        );
                      },
                      icon: Icon(Icons.share, color: joke.colors[0]),
                      label: Text(
                        'Share This Joke',
                        style: TextStyle(color: joke.colors[0]),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: joke.colors[0]),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJokeCard(_FunnyWish joke) {
    return Container(
      key: ValueKey(joke.text),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: joke.colors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: joke.colors[0].withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            joke.emoji,
            style: const TextStyle(fontSize: 64),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: 500.ms,
              ),
          const SizedBox(height: 24),
          Text(
            joke.text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _FunnyWish {
  final String emoji;
  final String text;
  final List<Color> colors;
  const _FunnyWish(this.emoji, this.text, this.colors);
}
