# Boba Go! 🧋

A mobile adaptation of the popular board game Sushi Go! reimagined with bubble tea themes and strategic card gameplay.

## Overview

Boba Go! is a fast-paced, easy-to-learn card game where players compete against intelligent CPU opponents to earn the most points by strategically selecting cards from a rotating "menu" of boba ingredients and related items. Players select cards and pass hands until all cards are played, with scoring based on collected card combinations across three rounds.

## Features

### Core Gameplay
- **Strategic card selection** with 8 custom-designed boba-themed cards
- **Turn-based gameplay** with rotating hand mechanics
- **Three-round scoring system** with immediate and end-game point calculations
- **Interactive mini-games** including accelerometer-based shake mechanics

### Intelligent CPU
- **Adaptive CPU opponents** with weighted decision-making algorithms
- **Multiple difficulty levels** (Easy/Hard) with different strategic approaches
- **Player behavior prediction** and counter-strategy implementation

### Statistics & Progression
- **Comprehensive stat tracking**: highest scores, win/loss records, most used cards
- **Session data**: join date, total minutes played
- **Performance analytics** across multiple games

### Customization
- **Theme system** with multiple color schemes
- **Audio controls** for sound effects and background music
- **Accessibility options** including shake effect toggles
- **Settings persistence** across app sessions

### User Experience
- **Custom animations** for card selection and hand rotations
- **Responsive UI** supporting multiple screen sizes
- **Sound design** with contextual audio feedback
- **YouTube API integration** for tutorial content

## Technical Stack

- **Framework**: Flutter (Dart)
- **Audio**: Audioplayers plugin
- **Video**: YouTube Player Flutter
- **Sensors**: Device accelerometer integration
- **State Management**: Flutter state management
- **Persistence**: Local data storage

## Development Highlights

- **Progressive difficulty scaling** based on game state analysis
- **Real-time animation system** for card interactions
- **Cross-platform compatibility** (iOS/Android)
- **Memory-efficient state management** for smooth gameplay
- **Comprehensive testing** across device orientations and screen sizes

## Game Rules

Players select one card per turn from their hand, then pass the remaining cards to opponents. This continues until all cards are played (one round). Points are calculated based on card combinations, with some cards scoring immediately and others (desserts) scoring at game end. The player with the most points after three rounds wins!

## Installation

This project was developed as part of a mobile application development course. To run locally:

1. Ensure Flutter SDK is installed
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Launch with `flutter run`

## Future Enhancements

- **Multiplayer support** with online connectivity
- **Additional card sets** and game modes
- **Enhanced AI** with machine learning capabilities
- **Social features** including leaderboards and achievements

---

*Inspired by the original Sushi Go! board game, adapted with original boba tea themes and mobile-optimized gameplay mechanics.*