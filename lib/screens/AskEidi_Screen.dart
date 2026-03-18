import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;

class AskeidiScreen extends StatefulWidget {
  const AskeidiScreen({super.key});

  @override
  State<AskeidiScreen> createState() => _AskeidiScreenState();
}

class _AskeidiScreenState extends State<AskeidiScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────
  late ConfettiController _confettiCtrl;
  late AnimationController _floatController;
  late AnimationController _heartbeatController;
  late AnimationController _coinController;
  late AnimationController _shakeController;

  // ── State ─────────────────────────────────────────────────
  int _currentStep = 0; // 0: pick amount, 1: pick message, 2: preview
  int? _selectedPresetAmount;
  String _customAmount = '';
  int _selectedMessageIndex = 0;
  int _selectedRecipientType = 0;
  bool _showPreview = false;
  bool _isGenerating = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final PageController _msgPageController = PageController();

  // ── Preset Amounts ────────────────────────────────────────
  final List<_PresetAmount> _presetAmounts = const [
    _PresetAmount(50, '😊', 'Just a lil'),
    _PresetAmount(100, '🥺', 'Please bro'),
    _PresetAmount(200, '🤲', 'Blessing'),
    _PresetAmount(500, '🤩', 'Be generous'),
    _PresetAmount(1000, '💸', 'Masha Allah'),
    _PresetAmount(2000, '👑', 'Big love'),
  ];

  // ── Recipient Types ───────────────────────────────────────
  final List<_RecipientType> _recipientTypes = const [
    _RecipientType('👴', 'Uncle', 'Chachu/Mamu'),
    _RecipientType('👵', 'Auntie', 'Chachi/Mami'),
    _RecipientType('🧓', 'Dada/Dadi', 'Grandparents'),
    _RecipientType('💼', 'Boss', 'Work uncle'),
    _RecipientType('👨', 'Father', 'Abbu'),
    _RecipientType('👩', 'Mother', 'Ammi'),
  ];

  // ── Messages ─────────────────────────────────────────────
  final List<_EidiMessage> _messages = const [
    _EidiMessage(
      emoji: '🥺',
      tone: 'Ultra Emotional',
      color: Color(0xFF667eea),
      secondColor: Color(0xFF764ba2),
      shortText: 'The tears approach...',
      fullMessage:
          '''🌙 Eid Mubarak {name}! ✨

First of all, may Allah shower His endless blessings upon you, your family, and everyone you love. 🤲

You know, every year when Eid comes around, I think about how truly lucky I am to have someone like you in my life. You've always been there with love, warmth, and... and... Eidi. 💕

This year, my heart is filled with SO much love for you that I simply HAD to reach out. Not for anything materialistic of course... 

BUT if your loving heart feels inspired to send just \${amount} as Eidi... who am I to stop a blessing? 

After all, the Prophet ﷺ said that giving gifts increases love. So really... you'd be following Sunnah. 🌹

Taqabbalallahu minna wa minkum. 
Your forever grateful, {sender} 😇''',
    ),
    _EidiMessage(
      emoji: '😂',
      tone: 'Pure Comedy',
      color: Color(0xFFf093fb),
      secondColor: Color(0xFFf5576c),
      shortText: 'Brace yourself... 😂',
      fullMessage:
          '''Eid Mubarak {name}! 🎉

I hope this message finds you in good health, good spirits, and most importantly... 

WITH MONEY IN YOUR POCKET. 💰

Look, I've been a very good person this Ramadan. I fasted. I prayed. I was nice to the annoying cousin at the family gathering. I EARNED this.

So {name}, I'm humbly (but also quite confidently) requesting Eidi of \${amount}. 

Please note:
❌ Duas only - already have plenty
❌ Advice - not today uncle  
❌ "Beta study hard" - sir this is Eid
✅ Cash/Transfer - YES PLEASE 💸

Jazakallah Khair in advance!
- {sender} (your favourite, obviously) 😂''',
    ),
    _EidiMessage(
      emoji: '😇',
      tone: 'Innocent Child',
      color: Color(0xFF43e97b),
      secondColor: Color(0xFF38f9d7),
      shortText: 'Small child energy 🥛',
      fullMessage:
          '''Assalamu Alaikum {name}! 🌙

Eid Mubaaaaarak! 🎊✨

*does the cutest most adorable Eid hug imaginable*

You're my absolute favourite {name} in the whole entire world mashAllah! Did you know that? Because it is 100% true and has absolutely nothing to do with what I'm about to say next.

Soooo... you know how giving Eidi makes you get 10x the reward back? 🤩 I read that somewhere. Probably in a hadith. Don't fact-check this.

Anyway, \${amount} would be perfect. Not too much, not too little. Just right. Like Goldilocks but Islamic. 

Ammi says I have to say please so: PLEASE 🥺👉👈

Eid Mubarak again!
Love, {sender} 
(your cutest family member, statistically proven)''',
    ),
    _EidiMessage(
      emoji: '📊',
      tone: 'Business Proposal',
      color: Color(0xFFffd89b),
      secondColor: Color(0xFF19547b),
      shortText: 'Very professional 💼',
      fullMessage:
          '''RE: Eid Mubarak & Eidi Investment Opportunity

Dear {name},

Eid Mubarak. I trust this message finds you well.

I am writing to formally request your consideration of an Eidi contribution of \${amount} as part of our annual family happiness initiative.

KEY HIGHLIGHTS:
📈 ROI: Immeasurable blessings  
💝 Risk Level: Zero (sadaqah is always a win)
⭐ Happiness Index: +1000%
🤲 Allah ki khushi: Guaranteed (inshAllah)

This is a LIMITED TIME OFFER valid on Eid day only. 

Previous investors (last year's Eidi givers) reported:
✅ Increased family love
✅ Best child/niece/nephew award
✅ Bragging rights for 1 full year

I look forward to a mutually beneficial transaction.

Warm regards,
{sender}
Chief Eidi Officer (CEO) 💼''',
    ),
    _EidiMessage(
      emoji: '🌹',
      tone: 'Poet Mode',
      color: Color(0xFFa18cd1),
      secondColor: Color(0xFFfbc2eb),
      shortText: 'Shakespeare vibes ✍️',
      fullMessage:
          '''O {name}, blessed soul on this holy day, 🌙
As crescent moons and stars align to say,
That Eid has come with joy and morning light,
And you, dear one, have made my world so bright.

In the garden of family, you are the rose 🌹
The one whose generosity eternally flows,
And if that generosity, this blessed Eid,
Were \${amount}... that's really all I need.

The prophet said that gifts increase love's art,
And you, dear {name}, hold a piece of my heart.
So as the Takbir echoes through the air,
Know that your Eidi... I would gratefully bear.

Taqabbal O Gracious, O Kind, O Great,
With love and Eid wishes, I humbly await.

With eternal adoration,
{sender} 🌹✨''',
    ),
    _EidiMessage(
      emoji: '👨‍⚖️',
      tone: 'Legal Notice',
      color: Color(0xFF4facfe),
      secondColor: Color(0xFF00f2fe),
      shortText: 'This is legally binding 😤',
      fullMessage:
          '''OFFICIAL EID EIDI REQUEST NOTICE
Document No: EID-2026-{sender}

TO: {name}
FROM: {sender} (The Deserving Party)
RE: Annual Eidi Disbursement

This notice hereby serves as formal documentation that the undersigned ({sender}) is fully entitled to Eidi on this blessed occasion of Eid al-Fitr 1447H.

EVIDENCE OF ENTITLEMENT:
• Exhibit A: Completed full Ramadan (mostly 😅)
• Exhibit B: Made dua for {name} regularly  
• Exhibit C: Was extremely cute throughout the year
• Exhibit D: Has not received Eidi yet (criminal)

REQUESTED RELIEF: \${amount} (negotiable, but not really)

FAILURE TO COMPLY may result in:
⚠️ Sad puppy eyes for duration of Eid
⚠️ Dramatic sighs during family gathering
⚠️ You feeling guilty (trust the process)

Eid Mubarak! 🌙
Signed: {sender}
(Certified Eidi Deserving Person, Class of 2026)''',
    ),
  ];

  // ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _confettiCtrl =
        ConfettiController(duration: const Duration(seconds: 2));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _coinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _floatController.dispose();
    _heartbeatController.dispose();
    _coinController.dispose();
    _shakeController.dispose();
    _amountController.dispose();
    _nameController.dispose();
    _msgPageController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────

  int get _finalAmount =>
      _selectedPresetAmount ??
      (int.tryParse(_customAmount) ?? 0);

  String get _finalMessage {
    final msg = _messages[_selectedMessageIndex];
    final name = _nameController.text.trim().isEmpty
        ? _recipientTypes[_selectedRecipientType].label
        : _nameController.text.trim();
    return msg.fullMessage
        .replaceAll('{name}', name)
        .replaceAll('{amount}', _finalAmount.toString())
        .replaceAll('{sender}', 'Me 😊');
  }

  bool get _canProceed {
    if (_currentStep == 0) return _finalAmount > 0;
    if (_currentStep == 1) return true;
    return true;
  }

  void _nextStep() {
    if (!_canProceed) {
      _shakeController.forward().then((_) => _shakeController.reset());
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.mediumImpact();
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      if (_currentStep == 2) {
        Future.delayed(const Duration(milliseconds: 400), () {
          _confettiCtrl.play();
        });
      }
    }
  }

  void _prevStep() {
    HapticFeedback.lightImpact();
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _shareMessage() {
    HapticFeedback.heavyImpact();
    _confettiCtrl.play();
    Share.share(
      _finalMessage,
      subject: '🌙 Eid Mubarak & Eidi Request!',
    );
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0d0221),
              Color(0xFF1a0533),
              Color(0xFF0d1b2a),
            ],
          ),
        ),
        child: Stack(
          children: [
            // BG sparkles
            ..._buildBgSparkles(),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiCtrl,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.07,
                numberOfParticles: 25,
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

            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  _buildStepIndicator(),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder: (child, anim) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.4, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOutCubic,
                        )),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: _buildCurrentStep(),
                    ),
                  ),
                  _buildBottomNav(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ───────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_currentStep > 0) {
                _prevStep();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '💸 Ask for Eidi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'The most blessed request of Eid 😇',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber.withOpacity(0.8),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Floating coin animation
          AnimatedBuilder(
            animation: _coinController,
            builder: (_, __) => Transform.rotate(
              angle: _coinController.value * 2 * math.pi,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('💰', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP INDICATOR ────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Amount', 'Message', 'Preview'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: isDone || isActive
                          ? const LinearGradient(
                              colors: [Colors.amber, Colors.orange])
                          : null,
                      color: isDone || isActive
                          ? null
                          : Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(width: 6),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── CURRENT STEP ──────────────────────────────────────────
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildAmountStep();
      case 1:
        return _buildMessageStep();
      case 2:
        return _buildPreviewStep();
      default:
        return _buildAmountStep();
    }
  }

  // ══════════════════════════════════════════════════════════
  // STEP 1 — PICK AMOUNT
  // ══════════════════════════════════════════════════════════
  Widget _buildAmountStep() {
    return SingleChildScrollView(
      key: const ValueKey('step0'),
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Animated emoji header
          Center(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (_, __) => Transform.translate(
                offset: Offset(
                  0,
                  math.sin(_floatController.value * math.pi) * 8,
                ),
                child: Column(
                  children: [
                    const Text('🥺', style: TextStyle(fontSize: 64))
                        .animate()
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 700.ms,
                        ),
                    const SizedBox(height: 12),
                    const Text(
                      'How much do you deserve? 👀',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pick or type your target amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Preset amounts grid
          const Text(
            'Quick Pick 🎯',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: _presetAmounts.asMap().entries.map((entry) {
              final i = entry.key;
              final preset = entry.value;
              final isSelected = _selectedPresetAmount == preset.amount;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedPresetAmount = preset.amount;
                    _customAmount = '';
                    _amountController.clear();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected
                        ? null
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? Colors.amber
                          : Colors.white.withOpacity(0.15),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 14,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        preset.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${preset.amount}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                      Text(
                        preset.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white70
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: Duration(milliseconds: 60 * i))
                    .fadeIn(duration: 400.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                    ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Custom amount
          const Text(
            'Or Enter Custom Amount ✍️',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          AnimatedBuilder(
            animation: _shakeController,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                math.sin(_shakeController.value * math.pi * 8) * 6,
                0,
              ),
              child: child,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _customAmount.isNotEmpty
                      ? Colors.amber
                      : Colors.white.withOpacity(0.15),
                  width: _customAmount.isNotEmpty ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.25),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _customAmount = v;
                          if (v.isNotEmpty) {
                            _selectedPresetAmount = null;
                          }
                        });
                      },
                    ),
                  ),
                  if (_customAmount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        '💰',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (_finalAmount > 0) ...[
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'You\'re asking for \$$_finalAmount 🤑',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                  ),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // STEP 2 — PICK MESSAGE TONE + RECIPIENT
  // ══════════════════════════════════════════════════════════
  Widget _buildMessageStep() {
    return SingleChildScrollView(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Header
          Center(
            child: Column(
              children: [
                const Text('🎭', style: TextStyle(fontSize: 56))
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 12),
                const Text(
                  'Pick your strategy 😏',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Choose your weapon wisely...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Who to send to
          const Text(
            'Sending To 👤',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Name input
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: '  Enter their name (optional)',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.person_outline,
                    color: Colors.amber, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Recipient type selector
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recipientTypes.length,
              itemBuilder: (_, i) {
                final r = _recipientTypes[i];
                final isSelected = _selectedRecipientType == i;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedRecipientType = i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.amber
                            : Colors.white.withOpacity(0.15),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(r.emoji,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          r.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected ? Colors.white : Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Message tone picker
          const Text(
            'Choose Your Tone 🎭',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),

          ...List.generate(_messages.length, (i) {
            final msg = _messages[i];
            final isSelected = _selectedMessageIndex == i;

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedMessageIndex = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            msg.color.withOpacity(0.4),
                            msg.secondColor.withOpacity(0.3),
                          ],
                        )
                      : null,
                  color:
                      isSelected ? null : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? msg.color
                        : Colors.white.withOpacity(0.12),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: msg.color.withOpacity(0.3),
                            blurRadius: 14,
                            spreadRadius: 1,
                          )
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [msg.color, msg.secondColor],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          msg.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.tone,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            msg.shortText,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white60
                                  : Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: Colors.amber, size: 22),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 60 * i))
                  .fadeIn(duration: 350.ms)
                  .slideX(begin: 0.2, end: 0),
            );
          }),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // STEP 3 — PREVIEW & SHARE
  // ══════════════════════════════════════════════════════════
  Widget _buildPreviewStep() {
    final msg = _messages[_selectedMessageIndex];

    return SingleChildScrollView(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Header
          AnimatedBuilder(
            animation: _heartbeatController,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + (_heartbeatController.value * 0.08),
              child: const Text(
                '🥺💸',
                style: TextStyle(fontSize: 56),
              ),
            ),
          ).animate().scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 14),

          const Text(
            'Your Eidi Request is Ready!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate(delay: 200.ms).fadeIn(),

          Text(
            'Preview before you send 👀',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.5),
            ),
          ).animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 24),

          // Amount badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 14,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Text(
                  'Requesting: \$${_finalAmount} 💰',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ).animate(delay: 400.ms).fadeIn().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 20),

          // Message preview card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  msg.color.withOpacity(0.25),
                  msg.secondColor.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: msg.color.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: msg.color.withOpacity(0.2),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tone badge
                Row(
                  children: [
                    Text(msg.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [msg.color, msg.secondColor]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg.tone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.white12),
                const SizedBox(height: 14),

                // Message text (preview — first 300 chars)
                Text(
                  _finalMessage.length > 340
                      ? '${_finalMessage.substring(0, 340)}...'
                      : _finalMessage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '👆 Full message will be shared',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 22),

          // Tip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pro Tip: Send right after saying "Eid Mubarak" for maximum effectiveness! 😂',
                    style: TextStyle(
                      color: Colors.amber.withOpacity(0.9),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 700.ms).fadeIn(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────
  Widget _buildBottomNav() {
    final isLastStep = _currentStep == 2;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLastStep) ...[
            // Share button (beautiful)
            GestureDetector(
              onTap: _shareMessage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('💸', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Text(
                      'Send My Eidi Request!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Start over
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _currentStep = 0;
                  _selectedPresetAmount = null;
                  _customAmount = '';
                  _amountController.clear();
                  _nameController.clear();
                  _selectedMessageIndex = 0;
                  _selectedRecipientType = 0;
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.white38, size: 16),
              label: const Text(
                'Make another request 😇',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          ] else ...[
            // Next step button
            GestureDetector(
              onTap: _nextStep,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: _canProceed
                      ? const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        )
                      : null,
                  color: _canProceed
                      ? null
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _canProceed
                      ? [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == 0
                            ? 'Pick Message Style'
                            : 'Preview Request',
                        style: TextStyle(
                          color: _canProceed ? Colors.white : Colors.white38,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _canProceed ? Colors.white : Colors.white38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_currentStep == 0 && _finalAmount == 0) ...[
              const SizedBox(height: 8),
              const Text(
                'Pick or enter an amount to continue',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ── BG SPARKLES ───────────────────────────────────────────
  List<Widget> _buildBgSparkles() {
    return List.generate(20, (i) {
      final r = math.Random(i * 73);
      return Positioned(
        left: r.nextDouble() * 400,
        top: r.nextDouble() * 800,
        child: Opacity(
          opacity: r.nextDouble() * 0.3 + 0.05,
          child: Text(
            ['✨', '⭐', '💫', '🌟', '💰'][i % 5],
            style: TextStyle(fontSize: r.nextDouble() * 12 + 8),
          ),
        )
            .animate(
              onPlay: (c) => c.repeat(reverse: true),
              delay: Duration(milliseconds: r.nextInt(3000)),
            )
            .fadeIn(
              duration: Duration(milliseconds: 1500 + r.nextInt(2000)),
            ),
      );
    });
  }
}

// ── MODELS ────────────────────────────────────────────────
class _PresetAmount {
  final int amount;
  final String emoji;
  final String label;
  const _PresetAmount(this.amount, this.emoji, this.label);
}

class _RecipientType {
  final String emoji;
  final String label;
  final String subtitle;
  const _RecipientType(this.emoji, this.label, this.subtitle);
}

class _EidiMessage {
  final String emoji;
  final String tone;
  final Color color;
  final Color secondColor;
  final String shortText;
  final String fullMessage;
  const _EidiMessage({
    required this.emoji,
    required this.tone,
    required this.color,
    required this.secondColor,
    required this.shortText,
    required this.fullMessage,
  });
}
