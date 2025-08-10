import 'package:flutter/material.dart';

String selectedTheme = "Pink";
bool isShakeEnabled = true;
bool hardDifficulty = false;
bool soundEffectsOn = true;

final Map<String, Color> themeColors = {
  "Pink": Colors.pink[100]!,
  "Blue": Colors.blue[100]!,
  "Green": Colors.green[100]!,
  "Tan": Colors.brown[100]!,
};

final Map<String, Color> themeAccentColors = {
  "Pink": Colors.pink[700]!,
  "Blue": Colors.blue[700]!,
  "Green": Colors.green[700]!,
  "Tan": Colors.brown[700]!
};

final Map<String, String> themeBlankCardMap = {
  "Pink": 'assets/blank-card.png',
  "Blue": 'assets/blank-card-blue.png',
  "Green": 'assets/blank-card-green.png',
  "Tan": 'assets/blank-card-tan.png',
};

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeAccentColors[selectedTheme],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Settings",
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
              themeColors[selectedTheme]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Settings Section
                _buildSectionTitle("Game Settings"),
                const SizedBox(height: 10),
                _buildSettingsCard(
                  title: "Sound Effects",
                  subtitle: "Enable or disable game sound effects",
                  trailing: Switch(
                    value: soundEffectsOn,
                    onChanged: (value) {
                      setState(() {
                        soundEffectsOn = value;
                      });
                    },
                    activeColor: themeAccentColors[selectedTheme],
                  ),
                ),
                _buildSettingsCard(
                  title: "Hard Difficulty CPUs",
                  subtitle: "Toggle on smarter CPU logic",
                  trailing: Switch(
                    value: hardDifficulty,
                    onChanged: (value) {
                      setState(() {
                        hardDifficulty = value;
                      });
                    },
                    activeColor: themeAccentColors[selectedTheme]!,
                  ),
                ),
                _buildSettingsCard(
                  title: "Shake Effect",
                  subtitle: "Enable shake detection during minigames",
                  trailing: Switch(
                    value: isShakeEnabled,
                    onChanged: (value) {
                      setState(() {
                        isShakeEnabled = value;
                      });
                    },
                    activeColor: themeAccentColors[selectedTheme]!,
                  ),
                ),


                const SizedBox(height: 20),

                // Theme Selector Section
                _buildSectionTitle("Select Theme"),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: themeAccentColors[selectedTheme]!.withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTheme,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.palette, color:themeAccentColors[selectedTheme]),
                      style: TextStyle(
                        color: themeAccentColors[selectedTheme],
                        fontSize: 16,
                      ),
                      items: themeColors.keys.map((String theme) {
                        return DropdownMenuItem(
                          value: theme,
                          child: Text(theme),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTheme = newValue!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context,
                          {
                            'color': themeColors[selectedTheme],
                            'accentColor': themeAccentColors[selectedTheme],
                            'blankCard': themeBlankCardMap[selectedTheme],
                            'soundEffectsOn': soundEffectsOn,
                            'hardDifficulty': hardDifficulty,
                            'shakeEnabled': isShakeEnabled, // Add this line
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeAccentColors[selectedTheme],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Save Settings",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom section title widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: themeAccentColors[selectedTheme],
      ),
    );
  }

  // Custom settings card widget
  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: themeAccentColors[selectedTheme]!.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: themeAccentColors[selectedTheme],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: themeAccentColors[selectedTheme],
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}