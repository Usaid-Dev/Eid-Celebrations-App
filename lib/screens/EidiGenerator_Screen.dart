import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

class EidigeneratorScreen extends StatefulWidget {
  const EidigeneratorScreen({super.key});

  @override
  State<EidigeneratorScreen> createState() => _EidigeneratorScreenState();
}

class _EidigeneratorScreenState extends State<EidigeneratorScreen> {
  late ConfettiController _confettiCtrl;
  int _age = 18;
  String _relation = 'Son/Daughter';
  bool _isGoodChild = true;
  bool _prayedFajr = false;
  bool _helpedMom = false;
  _EidiResult? _result;
  bool _isCalculating = false;

  final List<String> _relations = [
    'Son/Daughter',
    'Nephew/Niece',
    'Grandchild',
    'Neighbour\'s kid',
    'Random cousin',
    'Uncle (yes really)',
  ];

  final List<_EidiResult> _results = const [
    _EidiResult('💸 \$500!', 'You\'re literally the favourite! 🏆', Colors.green),
    _EidiResult('💵 \$200', 'Pretty good! Keep being adorable 😇', Colors.teal),
    _EidiResult('💴 \$100', 'Not bad at all! Auntie loves you.', Colors.blue),
    _EidiResult('💵 \$50', 'Decent... could\'ve been worse 😅', Colors.indigo),
    _EidiResult('🪙 \$10', 'Uncle said "it\'s the thought that counts" 😬', Colors.orange),
    _EidiResult('🍬 Some candy', '"This is the same as money." — Uncle 🙃', Colors.pink),
    _EidiResult('🤲 A dua only', 'May Allah bless you with actual cash... 😂', Colors.purple),
    _EidiResult('👀 "Ask your father"', 'The most classic Eid response of all time!', Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (_isCalculating) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _isCalculating = true;
      _result = null;
    });

    await Future.delayed(const Duration(milliseconds: 2200));

    // Score-based system
    int score = 0;
    if (_isGoodChild) score += 3;
    if (_prayedFajr) score += 2;
    if (_helpedMom) score += 2;
    if (_age <= 10) score += 3;
    else if (_age <= 15) score += 2;
    else if (_age <= 20) score += 1;
    if (_relation == 'Son/Daughter') score += 2;
    else if (_relation == 'Grandchild') score += 3;

    final index = ((_results.length - 1) -
            (score.clamp(0, 10) * (_results.length - 1) ~/ 10))
        .clamp(0, _results.length - 1);

    HapticFeedback.heavyImpact();
    _confettiCtrl.play();

    setState(() {
      _result = _results[index];
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0d1b2a), Color(0xFF1b4332)],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              numberOfParticles: 20,
              colors: const [
                Colors.amber, Colors.green, Colors.orange, Colors.pink
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                      const Text(
                        '💰 Eidi Calculator',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Answer honestly to find out\nhow much Eidi you REALLY deserve 😂',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age
                        Text(
                          'Your Age: $_age 🎂',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.amber,
                            inactiveTrackColor:
                                Colors.white.withOpacity(0.2),
                            thumbColor: Colors.amber,
                            overlayColor: Colors.amber.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _age.toDouble(),
                            min: 1,
                            max: 60,
                            divisions: 59,
                            onChanged: (v) {
                              HapticFeedback.selectionClick();
                              setState(() => _age = v.toInt());
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Relation
                        const Text(
                          'You are their... 👨‍👩‍👧',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _relation,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1b4332),
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            onChanged: (v) =>
                                setState(() => _relation = v!),
                            items: _relations
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 8),

                        _buildSwitch(
                          '😇 Good child overall?',
                          _isGoodChild,
                          (v) => setState(() => _isGoodChild = v),
                        ),
                        _buildSwitch(
                          '🌅 Prayed Fajr this morning?',
                          _prayedFajr,
                          (v) => setState(() => _prayedFajr = v),
                        ),
                        _buildSwitch(
                          '🧹 Helped mom today?',
                          _helpedMom,
                          (v) => setState(() => _helpedMom = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Calculate button
                  GestureDetector(
                    onTap: _calculate,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isCalculating
                              ? [Colors.grey.shade700, Colors.grey.shade600]
                              : [
                                  const Color(0xFFFFB300),
                                  const Color(0xFFFF6F00),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isCalculating
                            ? const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Calculating... 🥁',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                '🎲 Calculate My Eidi!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Result
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _result!.color,
                            _result!.color.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _result!.color.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'You deserve...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _result!.amount,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _result!.message,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 800.ms,
                        )
                        .fadeIn(),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
            activeColor: Colors.amber,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }
}

class _EidiResult {
  final String amount;
  final String message;
  final Color color;
  const _EidiResult(this.amount, this.message, this.color);
}
