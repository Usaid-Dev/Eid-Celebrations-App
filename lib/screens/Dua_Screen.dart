import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  int _currentIndex = 0;

  final List<_DuaItem> _duas = const [
    _DuaItem(
      arabic: 'تَقَبَّلَ اللَّهُ مِنَّا وَمِنكُم',
      transliteration: 'Taqabbalallahu minna wa minkum',
      translation: 'May Allah accept (good deeds) from us and from you',
      emoji: '🤲',
    ),
    _DuaItem(
      arabic: 'عيد مبارك وكل عام وأنتم بخير',
      transliteration: 'Eid Mubarak wa kull \'am wa antum bikhair',
      translation: 'Blessed Eid and may every year find you well',
      emoji: '🌙',
    ),
    _DuaItem(
      arabic: 'اللَّهُمَّ تَقَبَّلْ مِنَّا صِيَامَنَا وَقِيَامَنَا',
      transliteration: 'Allahumma taqabbal minna siyamana wa qiyamana',
      translation: 'O Allah, accept our fasting and our night prayers',
      emoji: '⭐',
    ),
    _DuaItem(
      arabic: 'اللَّهُمَّ بَارِكْ لَنَا فِي هَذَا الْيَوْمِ',
      transliteration: 'Allahumma barik lana fi hadha alyawm',
      translation: 'O Allah, bless us on this day',
      emoji: '🌟',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0533), Color(0xFF2d1b4e)],
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
                      '🤲 Eid Duas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Dua page view
              Expanded(
                child: PageView.builder(
                  itemCount: _duas.length,
                  onPageChanged: (i) {
                    HapticFeedback.selectionClick();
                    setState(() => _currentIndex = i);
                  },
                  itemBuilder: (_, i) => _buildDuaCard(_duas[i]),
                ),
              ),

              // Dots
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _duas.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: i == _currentIndex ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == _currentIndex
                            ? Colors.amber
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDuaCard(_DuaItem dua) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dua.emoji, style: const TextStyle(fontSize: 56))
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: 600.ms,
              ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.3),
                  Colors.indigo.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Text(
                  dua.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.amber,
                    height: 1.7,
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 500.ms),
                const SizedBox(height: 18),
                Text(
                  dua.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(color: Colors.white12),
                ),
                Text(
                  dua.translation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white60,
                    height: 1.6,
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 500.ms),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: '${dua.arabic}\n${dua.transliteration}\n${dua.translation}',
                ),
              );
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📋 Dua copied to clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.copy, color: Colors.white70),
            label: const Text(
              'Copy Dua',
              style: TextStyle(color: Colors.white70),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.25)),
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '← Swipe for more duas →',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DuaItem {
  final String arabic;
  final String transliteration;
  final String translation;
  final String emoji;
  const _DuaItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.emoji,
  });
}
