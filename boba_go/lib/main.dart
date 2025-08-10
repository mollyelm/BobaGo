// WORKING VERSION
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:boba_go/homepage.dart';
import 'package:boba_go/settings_page.dart';
import 'package:boba_go/cards.dart' as game_cards;
import 'package:boba_go/deck.dart';
import 'package:boba_go/player.dart';
import 'package:boba_go/cpu.dart';
import 'package:boba_go/statistics.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

// app entry point
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GameStats.sessionStartTime ??= DateTime.now();
  }

  @override
  void dispose() {
    GameStats.updateSessionTime();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      GameStats.updateSessionTime();
    } else if (state == AppLifecycleState.resumed) {
      GameStats.sessionStartTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boba Go!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3E2723),
          primary: const Color(0xFF3E2723),
          secondary: const Color(0xFFA1887F),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const GamePanel(),
    );
  }
}

class GamePanel extends StatefulWidget {
  const GamePanel({super.key});
  static int turnNumber = 1;
  static int roundNumber = 1;
  static const int totalRounds = 3;
  static const int handSize = 10; // 10 cards for 2 players

  @override
  State<GamePanel> createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> with TickerProviderStateMixin {
  // theme variables
  String currentTheme = selectedTheme; // Default theme from settings_page.dart
  Color backgroundColor = themeColors[selectedTheme]!;
  Color accentColor = themeAccentColors[selectedTheme]!;
  String blankCardAsset = themeBlankCardMap[selectedTheme]!;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  double _accelerationThreshold = 10.0;
  bool isShakeEnabled = true;

  // game state variables
  late Deck deck;
  late Player humanPlayer;
  late CPU cpuPlayer;

  bool isGameStarted = false;
  bool isWaitingForFlip = false;
  bool isCardFaceDown = true;

  // dessert tracking
  List<game_cards.Card> humanDesserts = [];
  List<game_cards.Card> cpuDesserts = [];

  // card selection
  int? selectedCardIndex;
  int? raisedCardIndex;
  String? _expandedCardImage;

  // animation state
  String countdownText = "";
  bool isShowingCountdown = false;

  // matcha shake game
  bool isShakingMatcha = false;
  int playerShakeCount = 0;
  int cpuShakeCount = 0;
  DateTime? lastShakeTime;

  // ui state
  bool isPaused = false;
  int? hoveredCardIndex;

  // ui colors
  final Color lightBrownColor = const Color(0xFFD7CCC8);

  // sound stuff
  double volume = 1.0;
  bool soundEffectsOn = true;
  Map<String, AudioPlayer> soundController = {};

  // CPU difficulty
  bool hardDifficulty = false;


  @override
  void initState() {


    super.initState();
    soundSetup();
    _setupShakeDetection();

    // start game

    initializeGame();

  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    super.dispose();
  }

  // fill sound map
  void soundSetup() {
    AudioPlayer countdown = AudioPlayer();
    AssetSource countdownSrc = AssetSource('bobago3hit.mp3');
    countdown.setSource(countdownSrc);
    countdown.setVolume(1.5);
    countdown.setReleaseMode(ReleaseMode.stop);
    setState(() {
      soundController["countdown"] = countdown;
    });

    AudioPlayer cardNoise = AudioPlayer();
    AssetSource cardNoiseSrc = AssetSource('cardnoise1.mp3');
    cardNoise.setSource(cardNoiseSrc);
    cardNoise.setPlayerMode(PlayerMode.mediaPlayer);
    cardNoise.setReleaseMode(ReleaseMode.stop);
    setState(() {
      soundController["cardNoise"] = cardNoise;
    });
  }

  // Navigate to settings and handle theme changes
  void navigateToSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );

    // Check if we received theme data back from settings
    if (result != null && result is Map) {
      setState(() {
        // Update theme variables
        if (result['color'] != null) {
          backgroundColor = result['color'];
        }
        if (result['accentColor'] != null) {
          accentColor = result['accentColor'];
        }
        if (result['blankCard'] != null) {
          blankCardAsset = result['blankCard'];
        }

        // Update sound effects
        if (result['soundEffectsOn'] != null) {
          soundEffectsOn = result['soundEffectsOn'];
        }

        // Update difficulty
        if (result['hardDifficulty'] != null) {
          hardDifficulty = result['hardDifficulty'];
        }

        // Update shake setting
        if (result['shakeEnabled'] != null) {
          isShakeEnabled = result['shakeEnabled'];
        }


        currentTheme = selectedTheme;
      });
    }
  }


  // game initialization
  void initializeGame() {
    humanPlayer = Player(name: 'You');
    cpuPlayer = CPU();

    humanDesserts = [];
    cpuDesserts = [];

    deck = Deck();
    deck.shuffle();

    dealCards();
    sortPlayerHand();

    GamePanel.roundNumber = 1;
    GamePanel.turnNumber = 1;

    setState(() {
      isGameStarted = true;
    });
  }

  // deal cards to players
  void dealCards() {
    humanPlayer.hand.clear();
    cpuPlayer.hand.clear();

    for (int i = 0; i < GamePanel.handSize; i++) {
      if (deck.cards.isNotEmpty) {
        humanPlayer.hand.add(deck.cards.removeAt(0));

      }
      if (deck.cards.isNotEmpty) {
        cpuPlayer.hand.add(deck.cards.removeAt(0));
      }
    }
  }

  // organize player's hand
  void sortPlayerHand() {
    humanPlayer.hand.sort((a, b) {
      int typeComparison = a.type.index.compareTo(b.type.index);
      if (typeComparison != 0) {
        return typeComparison;
      }
      return a.name.compareTo(b.name);
    });
  }

  // get card image
  String getCardImage(game_cards.Card card) {
    return card.image;
  }

  // main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: isShakingMatcha && !isShakeEnabled ? handlePlayerTap : null,
          child: Stack(
            children: [
              Container(
                color: backgroundColor,
                child: Row(
                  children: [
                    // menu section
                    SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          _buildControls(),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: _buildCompactMenu(),
                                ),
                                _buildGameInfo(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // game board
                    Expanded(
                      child: _buildGamePanel(),
                    ),
                  ],
                ),
              ),
              // overlay messages
              if (isShowingCountdown)
                Center(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isShakingMatcha
                            ? Colors.green.withValues(alpha: 0.8)
                            : accentColor.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            countdownText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isShakingMatcha) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Your shakes: $playerShakeCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'CPU shakes: $cpuShakeCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap the screen rapidly!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ],
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

  // added statistics button cpontrols
  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
                if (isPaused) {
                  _showPauseMenu();
                }
              });
            },
            style: IconButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.all(8),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              navigateToSettings();
            },
            style: IconButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.all(8),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.bar_chart,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticsPage()),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  // pause menu
  void _showPauseMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Game Paused',
            textAlign: TextAlign.center,
            style:
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPaused = false;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Resume',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // menu display
  Widget _buildCompactMenu() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuCard('assets/milktea-card.png'),
                        const SizedBox(width: 4),
                        _buildMenuCard('assets/yakult-card.png'),
                        const SizedBox(width: 4),
                        _buildMenuCard('assets/milkfoam-menu.png'),
                        const SizedBox(width: 4),
                        _buildMenuCard('assets/straw-menu.png'),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMenuCard('assets/popboba-menu.png'),
                      const SizedBox(width: 4),
                      _buildMenuCard('assets/cocojelly-menu.png'),
                      const SizedBox(width: 4),
                      _buildMenuCard('assets/matchalatte-menu.png'),
                      const SizedBox(width: 4),
                      _buildMenuCard('assets/mochidonut-menu.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // score display
  Widget _buildGameInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCompactScore('CPU', cpuPlayer.score, isActive: false),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Round ${GamePanel.roundNumber}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildCompactScore('You', humanPlayer.score, isActive: true),
        ],
      ),
    );
  }

  // menu card display
  Widget _buildMenuCard(String imagePath) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // CLOSE BUTTON
                  Positioned(
                    top: 3,
                    right: 35,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 75,
        width: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // score indicator
  Widget _buildCompactScore(String label, int score, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: lightBrownColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '$label: $score',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // main game board
  Widget _buildGamePanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // CPU area
            Expanded(
              child: _buildPlayerArea(isPlayer: false),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: const Color(0xFFE0E0E0),
            ),
            // player area
            Expanded(
              child: _buildPlayerArea(isPlayer: true),
            ),
          ],
        ),
      ),
    );
  }

  // player/CPU area layout
  Widget _buildPlayerArea({required bool isPlayer}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        flex: _calculateHandFlex(isPlayer),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: lightBrownColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isPlayer ? 'Your Cards' : 'CPU Cards',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                              child: _buildHandCards(isPlayer),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: _calculatePlayedCardsFlex(isPlayer),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: lightBrownColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Played',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: _buildPlayedCards(isPlayer),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: lightBrownColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Desserts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: _buildDessertStack(isPlayer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateHandFlex(bool isPlayer) {
    final player = isPlayer ? humanPlayer : cpuPlayer;
    final handSize = player.hand.length;
    final maxHandSize = 10;

    return math.max(3, math.min(8, 3 + ((handSize * 5) ~/ maxHandSize)));
  }

  int _calculatePlayedCardsFlex(bool isPlayer) {
    final player = isPlayer ? humanPlayer : cpuPlayer;
    final playedCardsCount = player.playedCards.length;
    return math.max(2, math.min(7, 2 + playedCardsCount));
  }

  // hand cards display
  Widget _buildHandCards(bool isPlayer) {

    List<Widget> cardWidgets = [];

    if (isGameStarted) {
      final player = isPlayer ? humanPlayer : cpuPlayer;
      final handSize = player.hand.length;

      if (handSize > 0) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final spreadFactor = 30.0 + (10 - handSize) * 3.0;

            for (int i = 0; i < handSize; i++) {
              final card = player.hand[i];

              // Center single card, otherwise spread based on count
              final leftPosition = handSize == 1
                  ? (availableWidth - 85) / 2
                  : 10.0 + (i * math.min(spreadFactor, (availableWidth - 95) / math.max(1, handSize - 1)));

              cardWidgets.add(
                Positioned(
                  left: leftPosition,
                  top: raisedCardIndex == i && isPlayer ? -10 : 0,
                  child: GestureDetector(
                    onTap: () {
                      if (isPlayer && !isWaitingForFlip) {
                        if (soundEffectsOn) {
                          soundController['cardNoise']!.resume();

                        }
                        if (raisedCardIndex == i) {
                          setState(() {
                            selectedCardIndex = i;
                            playSelectedCard();
                            raisedCardIndex = null;
                          });
                        } else {
                          setState(() {
                            raisedCardIndex = i;
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 120,
                      width: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: selectedCardIndex == i && isPlayer
                                ? accentColor.withOpacity(0.5)
                                : Colors.black.withAlpha(25),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isPlayer
                            ? Image.asset(getCardImage(card), fit: BoxFit.contain)
                            : Image.asset(blankCardAsset, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 130,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: cardWidgets,
              ),
            );
          },
        );
      }
    } else {
      List<String> cardImages = isPlayer
          ? [
        'assets/bsmt-card.png',
        'assets/1yakult-card.png',
        'assets/cocojelly-card.png',
        'assets/straw-card.png',
        'assets/tt-card.png'
      ]
          : [blankCardAsset, blankCardAsset, blankCardAsset, blankCardAsset, blankCardAsset];

      for (int i = 0; i < cardImages.length; i++) {
        cardWidgets.add(
          Positioned(
            left: 10.0 + (i * 45.0),
            top: 0,
            child: Container(
              height: 120,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isPlayer || i >= cardImages.length - 2
                    ? Image.asset(cardImages[i], fit: BoxFit.contain)
                    : Image.asset(blankCardAsset, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: cardWidgets,
      ),
    );
  }

  // play card from hand
  void playSelectedCard() {
    if (selectedCardIndex == null || selectedCardIndex! >= humanPlayer.hand.length) {
      return;
    }

    final selectedCard = humanPlayer.hand.removeAt(selectedCardIndex!);
    humanPlayer.playedCards.add(selectedCard);
    GameStats.trackCardUsage(selectedCard.name);

    selectedCardIndex = null;
    isWaitingForFlip = true;
    isCardFaceDown = true;

    handleCpuTurn();
  }

  // CPU turn logic
  void handleCpuTurn() {
    if (cpuPlayer.hand.isEmpty) {
      return;
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        if (hardDifficulty) {
          debugPrint("choosing smart");
          final cpuCard = cpuPlayer.smartChooseCard();
          cpuPlayer.hand.remove(cpuCard);
          cpuPlayer.playedCards.add(cpuCard);
          showCountdownAndFlip();
        } else {
          debugPrint("choosing");
          final cpuCard = cpuPlayer.chooseCard();
          cpuPlayer.hand.remove(cpuCard);
          cpuPlayer.playedCards.add(cpuCard);
          showCountdownAndFlip();
        }
      });
    });
  }

  // countdown animation
  void showCountdownAndFlip() {

    if (soundEffectsOn) {
      soundController["countdown"]!.resume();
    }



    setState(() {
      isShowingCountdown = true;
      countdownText = "3";
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        countdownText = "2";
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          countdownText = "1";
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            countdownText = "Flip!";
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              isShowingCountdown = false;
              flipCards();
            });
          });
        });
      });
    });
  }

  // reveal played cards
  void flipCards() {
    setState(() {
      isCardFaceDown = false;
    });

    bool humanPlayedMatcha = humanPlayer.playedCards.isNotEmpty &&
        humanPlayer.playedCards.last is game_cards.MatchaLatte;
    bool cpuPlayedMatcha = cpuPlayer.playedCards.isNotEmpty &&
        cpuPlayer.playedCards.last is game_cards.MatchaLatte;

    if (humanPlayedMatcha && cpuPlayedMatcha) {
      startMatchaShakeGame();
      return;
    }

    if (humanPlayer.hand.isEmpty && cpuPlayer.hand.isEmpty) {
      handleEndOfRound();
      return;
    }


    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isShowingCountdown = true;
        countdownText = "Swap Hands";
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isShowingCountdown = false;
        });
        performHandSwap();
      });
    });
  }


  // matcha shake minigame
  void startMatchaShakeGame() {
    setState(() {
      isShakingMatcha = true;
      playerShakeCount = 0;
      cpuShakeCount = 0;
      lastShakeTime = DateTime.now();
      isShowingCountdown = true;
      countdownText = isShakeEnabled ? "SHAKE!" : "TAP!";
    });

    if (isShakeEnabled) {
      _setupShakeDetection();
    }

    _startCpuShaking();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted ) {
        _accelerometerSubscription?.cancel();
        endMatchaShakeGame();
      }
    });
  }

  void _setupShakeDetection() {
    _accelerometerSubscription?.cancel();

    bool isUp = false;
    bool isDown = false;

    _accelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (!mounted) {
        _accelerometerSubscription?.cancel();
        return;
      }

      final acceleration = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (!isUp && acceleration > _accelerationThreshold) {
        isUp = true;
      }

      if (isUp && !isDown && acceleration < _accelerationThreshold * 0.5) {
        isDown = true;
      }

      if (isUp && isDown) {
        if (mounted) {
          setState(() {
            playerShakeCount++;
          });
        }
        isUp = false;
        isDown = false;

        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > 100) {
          _lastShakeTime = now;
        }
      }
    });
  }

  void _startCpuShaking() {
    final random = math.Random();
    final cpuSkillLevel = 0.7 + (random.nextDouble() * 0.5);

    int delay = random.nextInt(200) + 100;

    final missChance = random.nextDouble();

    if (isShakingMatcha && missChance > 0.2) {
      final shakeIncrement = random.nextDouble() < 0.15 ? 2 : 1;

      setState(() {
        cpuShakeCount += (shakeIncrement * cpuSkillLevel).round();
      });

      Future.delayed(Duration(milliseconds: delay), () {
        if (isShakingMatcha) {
          _startCpuShaking();
        }
      });
    } else if (isShakingMatcha) {
      // CPU "missed" a shake opportunity, but still tries again
      Future.delayed(Duration(milliseconds: delay), () {
        if (isShakingMatcha) {
          _startCpuShaking();
        }
      });
    }
  }

  // handle player shaking
  void handlePlayerShake() {
    if (!isShakingMatcha) return;
    final now = DateTime.now();
    if (lastShakeTime == null || now.difference(lastShakeTime!).inMilliseconds > 100) {
      setState(() {
        playerShakeCount++;
        lastShakeTime = now;
      });
    }
  }

  void handlePlayerTap() {
    if (!isShakingMatcha) return;
    final now = DateTime.now();
    if (lastShakeTime == null || now.difference(lastShakeTime!).inMilliseconds > 100) {
      setState(() {
        playerShakeCount++;
        lastShakeTime = now;
      });
    }
  }


  // end shake game
  void endMatchaShakeGame() {
    setState(() {
      isShakingMatcha = false;
      isShowingCountdown = false;

      if (playerShakeCount > cpuShakeCount) {
        for (var card in humanPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 3;
            break;
          }
        }
        for (var card in cpuPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 0;
            break;
          }
        }
      } else if (cpuShakeCount > playerShakeCount) {
        for (var card in cpuPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 3;
            break;
          }
        }
        for (var card in humanPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 0;
            break;
          }
        }
      } else {
        for (var card in humanPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 1;
            break;
          }
        }
        for (var card in cpuPlayer.playedCards) {
          if (card is game_cards.MatchaLatte) {
            card.shakeScore = 1;
            break;
          }
        }
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenSize = MediaQuery
            .of(context)
            .size;

        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.25,
              maxHeight: screenSize.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'Matcha Shake Results',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: accentColor
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your shakes: $playerShakeCount'),
                      Text('CPU shakes: $cpuShakeCount'),
                      const SizedBox(height: 16),
                      Text(
                        playerShakeCount > cpuShakeCount
                            ? 'You win 3 points!'
                            : (cpuShakeCount > playerShakeCount
                            ? 'CPU wins 3 points!'
                            : 'Tie! You both get 1 point.'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: accentColor),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isShowingCountdown = true;
                          countdownText = "Swap Hands";
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            isShowingCountdown = false;
                          });
                          performHandSwap();
                        });
                      },
                      child: Text(
                          'Continue', style: TextStyle(color: accentColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // swap hands between players
  void performHandSwap() {
    setState(() {
      final humanHand = List<game_cards.Card>.from(humanPlayer.hand);
      final cpuHand = List<game_cards.Card>.from(cpuPlayer.hand);
      humanPlayer.hand.clear();
      humanPlayer.hand.addAll(cpuHand);
      cpuPlayer.hand.clear();
      cpuPlayer.hand.addAll(humanHand);
      sortPlayerHand();
      isWaitingForFlip = false;
    });
  }

  // end of round processing
  void handleEndOfRound() {
    for (var card in List<game_cards.Card>.from(humanPlayer.playedCards)) {
      if (card.type == game_cards.CardType.dessert) {
        humanDesserts.add(card);
        humanPlayer.playedCards.remove(card);
      }
    }
    for (var card in List<game_cards.Card>.from(cpuPlayer.playedCards)) {
      if (card.type == game_cards.CardType.dessert) {
        cpuDesserts.add(card);
        cpuPlayer.playedCards.remove(card);
      }
    }

    int humanRoundScore = 0;
    int cpuRoundScore = 0;

    for (var card in humanPlayer.playedCards) {
      humanRoundScore += card.calculatePoints(humanPlayer, [humanPlayer, cpuPlayer]);
    }
    for (var card in cpuPlayer.playedCards) {
      cpuRoundScore += card.calculatePoints(cpuPlayer, [humanPlayer, cpuPlayer]);
    }

    humanPlayer.score += humanRoundScore;
    cpuPlayer.score += cpuRoundScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final maxHeight = screenSize.height * 0.7;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.25,
              maxHeight: maxHeight, // Limit height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'End of Round ${GamePanel.roundNumber}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: accentColor
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Points earned this round:'),
                          const SizedBox(height: 8),
                          Text('You: $humanRoundScore points'),
                          Text('CPU: $cpuRoundScore points'),
                          const SizedBox(height: 16),
                          Text('Total scores:'),
                          Text('You: ${humanPlayer.score} points'),
                          Text('CPU: ${cpuPlayer.score} points'),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (GamePanel.roundNumber < GamePanel.totalRounds) {
                          startNextRound();
                        } else {
                          calculateFinalScores();
                        }
                      },
                      child: Text(
                        'Continue to ${GamePanel.roundNumber < GamePanel.totalRounds ? 'Round ${GamePanel.roundNumber + 1}' : 'Final Results'}',
                        style: TextStyle(color: accentColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // start next round
  void startNextRound() {
    setState(() {
      GamePanel.roundNumber++;
      GamePanel.turnNumber = 1;
      humanPlayer.playedCards.clear();
      cpuPlayer.playedCards.clear();
      deck = Deck();
      deck.shuffle();
      dealCards();
      sortPlayerHand();
      isWaitingForFlip = false;
      isCardFaceDown = true;
    });
  }

  // calculate final game scores
  void calculateFinalScores() {
    int humanDessertScore = 0;
    int cpuDessertScore = 0;

    List<Player> playersWithDesserts = [humanPlayer, cpuPlayer];

    List<game_cards.Card> humanPlayedCardsSave = List.from(
        humanPlayer.playedCards);
    List<game_cards.Card> cpuPlayedCardsSave = List.from(cpuPlayer.playedCards);

    humanPlayer.playedCards = List.from(humanDesserts);
    cpuPlayer.playedCards = List.from(cpuDesserts);

    for (var card in humanDesserts) {
      humanDessertScore +=
          card.calculatePoints(humanPlayer, playersWithDesserts);
    }
    for (var card in cpuDesserts) {
      cpuDessertScore += card.calculatePoints(cpuPlayer, playersWithDesserts);
    }

    humanPlayer.playedCards = humanPlayedCardsSave;
    cpuPlayer.playedCards = cpuPlayedCardsSave;

    humanPlayer.score += humanDessertScore;
    cpuPlayer.score += cpuDessertScore;

    String winner = humanPlayer.score > cpuPlayer.score
        ? "You win!"
        : (humanPlayer.score < cpuPlayer.score ? "CPU wins!" : "It's a tie!");

    // update statistics
    GameStats.updateHighestScore(humanPlayer.score);
    if (humanPlayer.score > cpuPlayer.score) {
      GameStats.addWin();
    } else if (humanPlayer.score < cpuPlayer.score) {
      GameStats.addLoss();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenSize = MediaQuery
            .of(context)
            .size;
        final maxHeight = screenSize.height *
            0.7;

        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.25,
              maxHeight: maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'Game Over',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: accentColor
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dessert scores:'),
                          Text('You: $humanDessertScore points (${humanDesserts
                              .length} desserts)'),
                          Text('CPU: $cpuDessertScore points (${cpuDesserts
                              .length} desserts)'),
                          const SizedBox(height: 16),
                          Text('Final scores:'),
                          Text('You: ${humanPlayer.score} points'),
                          Text('CPU: ${cpuPlayer.score} points'),
                          const SizedBox(height: 16),
                          Text(
                              winner,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: accentColor
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        GameStats.updateSessionTime();

                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const HomePage()),
                              (route) => false,
                        );
                      },
                      child: Text('Return to Home',
                          style: TextStyle(color: accentColor)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        restartGame();
                      },
                      child: Text(
                          'Play Again', style: TextStyle(color: accentColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // restart game
  void restartGame() {
    setState(() {
      GamePanel.roundNumber = 1;
      GamePanel.turnNumber = 1;
      humanPlayer.score = 0;
      humanPlayer.hand.clear();
      humanPlayer.playedCards.clear();
      cpuPlayer.score = 0;
      cpuPlayer.hand.clear();
      cpuPlayer.playedCards.clear();
      humanDesserts.clear();
      cpuDesserts.clear();
      initializeGame();
    });
  }

  // played cards display
  Widget _buildPlayedCards(bool isPlayer) {
    final player = isPlayer ? humanPlayer : cpuPlayer;
    if (!isGameStarted || player.playedCards.isEmpty) {
      return const Center(
        child: Text(
          "No cards played yet",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final cardWidth = 85.0;
          final cardCount = player.playedCards.length;

          double baseSpacing = 25.0;

          if (cardCount > 2) {
            baseSpacing = math.max(10.0, 25.0 - ((cardCount - 2) * 2.0));
          }

          final totalWidth = cardWidth + (baseSpacing * (cardCount - 1));
          final scale = totalWidth > availableWidth ? availableWidth / totalWidth : 1.0;
          final scaledCardWidth = cardWidth * scale;
          final scaledSpacing = baseSpacing * scale;

          return Center(
            child: SizedBox(
              width: math.min(totalWidth, availableWidth),
              height: 120,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < cardCount; i++)
                    Positioned(
                      left: (math.min(totalWidth, availableWidth) - (scaledCardWidth + scaledSpacing * (cardCount - 1))) / 2
                          + (i * scaledSpacing),
                      child: Container(
                        width: scaledCardWidth,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: isCardFaceDown
                              ? Image.asset(blankCardAsset, fit: BoxFit.contain)
                              : Image.asset(getCardImage(player.playedCards[i]), fit: BoxFit.contain),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
    );
  }

  // dessert cards display
  Widget _buildDessertStack(bool isPlayer) {
    final dessertCards = isPlayer ? humanDesserts : cpuDesserts;
    if (!isGameStarted || dessertCards.isEmpty) {
      return const Center(
        child: Text(
          "No desserts collected",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return Center(
      child: SizedBox(
        width: 80,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < math.min(dessertCards.length, 3); i++)
              Positioned(
                top: i * 5.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        getCardImage(dessertCards[i]),
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
