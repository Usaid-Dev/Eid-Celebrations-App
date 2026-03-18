import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  // Eid al-Adha 2026 — approx June 17
  final DateTime _nextEid = DateTime(2026, 5, 27);

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final diff = _nextEid.difference(DateTime.now());
    if (mounted) {
      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0d1b2a), Color(0xFF1a1a2e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                      '⏳ Eid Countdown',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌙', style: TextStyle(fontSize: 72))
                          .animate()
                          .scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                          ),
                      const SizedBox(height: 20),
                      const Text(
                        'Next Eid al-Adha 2026',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white60,
                          letterSpacing: 1,
                        ),
                      ).animate(delay: 200.ms).fadeIn(),
                      const SizedBox(height: 8),
                      const Text(
                        'May 27, 2026',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber,
                          letterSpacing: 1,
                        ),
                      ).animate(delay: 300.ms).fadeIn(),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBox(
                              '$days', 'DAYS', Colors.amber),
                          _buildColon(),
                          _buildBox(
                              hours.toString().padLeft(2, '0'),
                              'HRS',
                              Colors.orange),
                          _buildColon(),
                          _buildBox(
                              minutes.toString().padLeft(2, '0'),
                              'MIN',
                              Colors.pink),
                          _buildColon(),
                          _buildBox(
                              seconds.toString().padLeft(2, '0'),
                              'SEC',
                              Colors.blue),
                        ],
                      )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 50),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: const Text(
                          '"Every second brings us closer\nto the most blessed day! 🤲\nMay we all reach it in good health."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontStyle: FontStyle.italic,
                            height: 1.7,
                          ),
                        ),
                      ).animate(delay: 600.ms).fadeIn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String val, String label, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color.withOpacity(0.7),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white30,
        ),
      ),
    );
  }
}
