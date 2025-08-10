# CMSC436 Project Proposal: Boba Go!

## Project Team 10

 * Nader Atta-Allah
 * Molly Moulton
 * Niki Surapaneni

## App Description

 This app is a Boba-inspired version of the popular board game Sushi Go. Players will compete against CPUs to earn the most points by selecting cards from a rotating “menu” of options. Each round, the player and CPUs will pass around a hand of cards, selecting one card from the hand each time. This continues until all the cards in each deck have been played. After each round, players will tally their points based on the card combinations they’ve collected. The game consists of three rounds, and the player with the most points at the end wins. As a fun twist, the app will feature interactive cards, such as the ability to shake the device for bonus points.

 Boba Go! will also feature a Stats tab where players can track their win/loss record, highest scores, and best plays. Additionally, there will be a Settings menu for customization, including toggling sound effects and music and enabling/disabling interactive features like shaking for bonus points.

## Minimal Goals

The app will contain two main tabs:

 * Card Game Interface
    * A deck of cards featuring different boba ingredients and related items, all having unique point specifiers.
    * Players rotate cards in a turn-based fashion, with all cards flipping when each player is finished drawing a card. 
    * Customizable background music and sound effects implemented with Spotify API, including music during gameplay, victory/defeat sound tracks, and special effect sounds for card combinations.
      * This is our feature beyond the scope of the course.
 * CPU
    * Players can play against an AI-controlled opponent. 
    * The CPU players will use basic strategies to simulate a competitive game.
 * Stats
    * Display the number of wins and losses
    * Display the highest score earned in a single turn across every game played
    * Show the best play made by the user
    * Display which card the user selects and plays the most
    * Displays the join date and hours played
 * Settings
    * Be able to to turn the sound and music on or off
    * Change the color theme of the game
    * Be able to turn the shake mobile effect on or off

## Stretch Goals

We have identified the following stretch goals:

 *  CPU
    * Change to have different levels of difficulties (Easy/Medium/Hard) for the CPU opponent(s)
    * Have a 3-player mode where 2 CPUs are used
 * Cards
    * Animate the interface/art for laying down cards
    * Animated hand rotations after each turn
 * Game State
    * Saving the game state when the app is closed and reloading it upon opening.
    * Notifications when players have not used the app for a considerable amount of time.

## Project Timeline

### Milestone 1

 * Finalize card game interface
 * Set up Spotify API
 * Create cards for the menu and assign point values
 * Keep track of each players points as the game progresses

### Milestone 2

 * CPU should function as an opposing player
 * The player stats page should keep track of and display player’s stats
 * Functional settings menu

### Milestone 3

 * Implementing a second CPU opponent for three person games
 * Saving the game state and display
 * Animated cards and beautification

### Final submission

Stretch goals completed, project submitted with a demonstration
video.
