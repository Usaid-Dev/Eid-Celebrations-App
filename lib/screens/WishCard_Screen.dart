import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

class WishcardScreen extends StatefulWidget {
  const WishcardScreen({super.key});

  @override
  State<WishcardScreen> createState() => _WishcardScreenState();
}

class _WishcardScreenState extends State<WishcardScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<_WishCard> cards = const [
    _WishCard(
      title: "Eid Mubarak! 🌙,",
      message:
          'May this blessed day fill your heart with joy, peace, and endless blessings!',
      emoji: '🎉',
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    _WishCard(
       title: "Eid Mubarak! 🌙,",
      message:
          'Wishing you and your beautiful family a very happy and blessed Eid al-Fitr!',
      emoji: '🕌',
      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    _WishCard(
       title: "Eid Mubarak! 🌙,",
      message:
          'May Allah shower His blessings upon you today, tomorrow, and always!',
      emoji: '🤲',
      colors: [Color(0xFF4facfe), Color.fromARGB(255, 23, 94, 98)],
    ),
    _WishCard(
       title: "Eid Mubarak! 🌙,",
      message:
          'May your Eid be filled with sweet moments and beautiful memories!',
      emoji: '🍰',
      colors: [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
    _WishCard(    
     title: "Eid Mubarak! 🌙,",
      message:
          'Eid Mubarak! May this holy occasion bring you closer to Allah and your loved ones.',
      emoji: '💖',
      colors: [Color.fromARGB(255, 35, 200, 90), Color.fromARGB(255, 43, 106, 95)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _shareCard() {
    HapticFeedback.mediumImpact();
    final card = cards[_currentIndex];
    Share.share(
      '${card.title}\n\n${card.message}\n\n🌙 Eid Mubarak! 🌙',
      subject: 'Eid Mubarak Wishes',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0533), Color(0xFF0d2137)],
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
                      '💌 Wish Cards',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Card swiper
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) {
                    HapticFeedback.selectionClick();
                    setState(() => _currentIndex = i);
                  },
                  itemCount: cards.length,
                  itemBuilder: (_, i) => _buildCard(cards[i]),
                ),
              ),

              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cards.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? Colors.amber
                          : Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Share button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: _shareCard,
                  icon: const Icon(Icons.share),
                  label: const Text(
                    'Share This Card',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cards[_currentIndex].colors[0],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor:
                        cards[_currentIndex].colors[0].withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_WishCard card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: card.colors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: card.colors[0].withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.emoji,
                  style: const TextStyle(fontSize: 72),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 28),
                Text(
                  card.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 18),
                Text(
                  card.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🌙 Swipe for more cards →',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WishCard {
  final String title;
  final String message;
  final String emoji;
  final List<Color> colors;

  const _WishCard({
    required this.title,
    required this.message,
    required this.emoji,
    required this.colors,
  });
}
