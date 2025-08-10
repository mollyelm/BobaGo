// lib/tutorial.dart
import 'package:flutter/material.dart';
import 'package:boba_go/settings_page.dart'; // for theme settings
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorialPage extends StatelessWidget {
  TutorialPage({super.key});

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: 'o0jdqucqqfQ',
    autoPlay: false,
    params: const YoutubePlayerParams(showFullscreenButton: false),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
        backgroundColor: themeAccentColors[selectedTheme],
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Welcome to Boba Go!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeAccentColors[selectedTheme],
                  ),
                ),

                Text(
                  '\nThis game is HEAVILY inspired by Sushi Go, a card game played using physical cards!\nif you\'re interested in learning how to play Boba Go!, this video might be useful to you!\n',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeAccentColors[selectedTheme],
                  ),
                ),
                YoutubePlayer(controller: _controller),
                Text(
                  '\nCredits go to Game Point on Youtube, Sushi Go!, and the Youtube API',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeAccentColors[selectedTheme],
                  ),
                )

                // Add more tutorial steps here
              ],
            ),
          ),
        ),
      ),
    );
  }
}