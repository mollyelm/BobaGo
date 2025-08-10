import 'package:flutter/material.dart';
import 'package:boba_go/settings_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the selected theme from settings_page.dart
    final themeColor = themeColors[selectedTheme]!;
    final accentColor = themeAccentColors[selectedTheme]!;

    // Format join date
    final joinDateStr = GameStats.joinDate != null
        ? "${GameStats.joinDate!.month}/${GameStats.joinDate!.day}/${GameStats.joinDate!.year}"
        : "Unknown";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Game Statistics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 24),
                // First row of stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.star,
                        title: 'Highest Score',
                        value: '${GameStats.highestScore}',
                        color: Colors.orange,
                        accentColor: accentColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.category,
                        title: 'Most Used Card',
                        value: GameStats.mostUsedCard,
                        color: Colors.green,
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Second row of stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.emoji_events,
                        title: 'Total Wins',
                        value: '${GameStats.totalWins}',
                        color: Colors.blue,
                        accentColor: accentColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.mood_bad,
                        title: 'Total Losses',
                        value: '${GameStats.totalLosses}',
                        color: Colors.red,
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Third row of stats - join date and play time
                Row(
                  children: [
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.calendar_today,
                        title: 'Join Date',
                        value: joinDateStr,
                        color: Colors.purple,
                        accentColor: accentColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatisticCard(
                        icon: Icons.timer,
                        title: 'Minutes Played',
                        value: '${GameStats.currentMinutesPlayed}',
                        color: Colors.teal,
                        accentColor: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color accentColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(
                icon,
                color: color,
                size: 34,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
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

// Game Statistics class for tracking game statistics
class GameStats {
  static int highestScore = 0;
  static String mostUsedCard = 'None';
  static int totalWins = 0;
  static int totalLosses = 0;
  static Map<String, int> cardUsage = {};
  static DateTime? joinDate;
  static int totalMinutesPlayed = 0;
  static DateTime? sessionStartTime;

  // Add a static flag to track if initialization has been done
  static bool _isInitialized = false;

  static void initializeStats() {
    // Only set join date if it's the first initialization
    if (!_isInitialized) {
      joinDate ??= DateTime.now();
      _isInitialized = true;
    }

    // Always update the session start time when initializing
    if (sessionStartTime == null) {
      sessionStartTime = DateTime.now();
    }
  }

  // Update the highest score if the new score is higher
  static void updateHighestScore(int score) {
    if (score > highestScore) {
      highestScore = score;
    }
  }

  // Update session time without resetting the sessionStartTime
  static void updateSessionTime() {
    if (sessionStartTime != null) {
      final now = DateTime.now();
      final sessionDuration = now.difference(sessionStartTime!);
      totalMinutesPlayed += sessionDuration.inMinutes;

      // Update the session start time to now without nullifying it
      sessionStartTime = now;
    }
  }

  static int get currentMinutesPlayed {
    int minutes = totalMinutesPlayed;

    // Add current session time if a session is active
    if (sessionStartTime != null) {
      final now = DateTime.now();
      final currentSessionMinutes = now.difference(sessionStartTime!).inMinutes;
      minutes += currentSessionMinutes;
    }

    return minutes;
  }

  // Update win count
  static void addWin() {
    totalWins++;
  }

  // Update loss count
  static void addLoss() {
    totalLosses++;
  }

  // Track card usage and update most used card
  static void trackCardUsage(String cardName) {
    if (cardUsage.containsKey(cardName)) {
      cardUsage[cardName] = cardUsage[cardName]! + 1;
    } else {
      cardUsage[cardName] = 1;
    }

    // Update most used card
    int highestUsage = 0;
    for (var entry in cardUsage.entries) {
      if (entry.value > highestUsage) {
        highestUsage = entry.value;
        mostUsedCard = entry.key;
      }
    }
  }
}