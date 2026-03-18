import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

class EidquizScreen extends StatefulWidget {
  const EidquizScreen({super.key});

  @override
  State<EidquizScreen> createState() => _EidquizScreenState();
}

class _EidquizScreenState extends State<EidquizScreen> {
  late ConfettiController _confettiCtrl;
  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;
  bool _isCorrect = false;

  final List<_QuizQuestion> _questions = const [
    _QuizQuestion(
      question: 'How many times do we say Takbir on Eid morning?',
      options: ['3 times', 'Continuously', '7 times', '100 times'],
      correctIndex: 1,
      explanation:
          'We say "Allahu Akbar" continuously on the way to the prayer ground!',
    ),
    _QuizQuestion(
      question: 'What is the Islamic name for Eid al-Fitr?',
      options: ['Festival of Sacrifice', 'Festival of Breaking Fast', 'Day of Joy', 'Holy Day'],
      correctIndex: 1,
      explanation: 'Eid al-Fitr celebrates the end of Ramadan fast!',
    ),
    _QuizQuestion(
      question: 'In which month does Eid al-Fitr occur?',
      options: ['Rajab', 'Shawwal', 'Dhul-Hijjah', 'Muharram'],
      correctIndex: 1,
      explanation: 'Eid al-Fitr is on the 1st of Shawwal!',
    ),
    _QuizQuestion(
      question: 'What is the primary purpose of Zakat al-Fitr?',
      options: [
        'Tax payment',
        'Purify the soul and help the poor',
        'Business transaction',
        'Entertainment fund'
      ],
      correctIndex: 1,
      explanation:
          'Zakat al-Fitr purifies our fasting and helps those in need!',
    ),
    _QuizQuestion(
      question: 'How many days of Eid celebration are there?',
      options: ['1 day', '3 days', '7 days', '30 days'],
      correctIndex: 1,
      explanation: 'Eid is celebrated for 3 days in many Muslim countries!',
    ),
    _QuizQuestion(
      question: 'What special greeting do we say on Eid?',
      options: [
        'Assalamu Alaikum',
        'Taqabbal allahu minna wa minkum',
        'Subhanallah',
        'Alhamdulillah'
      ],
      correctIndex: 1,
      explanation:
          'We say "Taqabbal allahu minna wa minkum" (May Allah accept from us and you)!',
    ),
    _QuizQuestion(
      question: 'Is it Sunnah to wear new clothes on Eid?',
      options: ['No, forbidden', 'Yes, it is Sunnah', 'Only for women', 'Only for children'],
      correctIndex: 1,
      explanation:
          'Wearing new or best clothes on Eid is part of the Sunnah!',
    ),
    _QuizQuestion(
      question: 'What is Eidi?',
      options: [
        'A type of prayer',
        'Gift money given to children',
        'Special Eid food',
        'Islamic holiday'
      ],
      correctIndex: 1,
      explanation: 'Eidi is a gift of money given to children on Eid! 💰',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedAnswer = _questions[_currentQuestion].options[index];
      _answered = true;
      _isCorrect = index == _questions[_currentQuestion].correctIndex;
      if (_isCorrect) {
        _score++;
        _confettiCtrl.play();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _nextQuestion() {
    HapticFeedback.lightImpact();
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a0533),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//  const Text(
//           '🎉 Quiz Complete!',
//           style: TextStyle(color: Colors.amber, fontSize: 24),
//         ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                ),
              ),
              child: Center(
                child: Text(
                  '$_score/${_questions.length}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getResultMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultMessage() {
    final percentage = (_score / _questions.length * 100).toInt();
    if (percentage == 100) return '🏆 Perfect Score! You\'re an Eid Master!';
    if (percentage >= 80) return '⭐ Excellent! You know a lot about Eid!';
    if (percentage >= 60) return '👍 Good! Keep learning about Eid!';
    if (percentage >= 40) return '📚 Not bad! Learn more about Eid!';
    return '💪 Keep trying! Study more about Eid!';
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a0533), Color(0xFF0d2137)],
          ),
        ),
        child: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiCtrl,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.08,
                numberOfParticles: 15,
                colors: const [Colors.amber, Colors.green, Colors.blue],
              ),
            ),

            SafeArea(
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
                          '🧠 Eid Quiz',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            '${_currentQuestion + 1}/${_questions.length}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.amber,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Question card
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Question emoji
                          Text('🤔', style: const TextStyle(fontSize: 50))
                              .animate()
                              .scale(
                                begin: const Offset(0, 0),
                                end: const Offset(1, 1),
                                curve: Curves.elasticOut,
                              ),

                          const SizedBox(height: 24),

                          // Question text
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.withOpacity(0.3),
                                  Colors.indigo.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),

                          const SizedBox(height: 28),

                          // Options
                          ...List.generate(
                            question.options.length,
                            (i) => _buildOptionButton(
                              question.options[i],
                              i,
                              i == question.correctIndex,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Explanation (if answered)
                          if (_answered)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _isCorrect
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isCorrect
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.red.withOpacity(0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _isCorrect ? '✅ Correct!' : '❌ Incorrect',
                                    style: TextStyle(
                                      color: _isCorrect
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    question.explanation,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Next button
                  if (_answered)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentQuestion == _questions.length - 1
                              ? 'See Results'
                              : 'Next Question',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, int index, bool isCorrect) {
    final isSelected = _selectedAnswer == option;
    Color buttonColor;
    Color textColor;

    if (!_answered) {
      buttonColor = Colors.white.withOpacity(0.1);
      textColor = Colors.white;
    } else if (isSelected) {
      buttonColor =
          isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3);
      textColor = isCorrect ? Colors.green : Colors.red;
    } else if (isCorrect) {
      buttonColor = Colors.green.withOpacity(0.2);
      textColor = Colors.green;
    } else {
      buttonColor = Colors.white.withOpacity(0.08);
      textColor = Colors.white60;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isCorrect ? Colors.green : Colors.red)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textColor.withOpacity(0.2),
                border: Border.all(color: textColor, width: 1.5),
              ),
              child: Center(
                child: isSelected
                    ? Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: textColor,
                        size: 16,
                      )
                    : Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected && isCorrect)
              const Text('✅', style: TextStyle(fontSize: 20)),
            if (isSelected && !isCorrect)
              const Text('❌', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0);
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
