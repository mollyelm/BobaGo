import 'package:boba_go/player.dart';
import 'dart:math' as math;

enum CardType { // the different card types
  boba, // all three different types
  yakult,
  special,
  appetizer,
  dessert
}

abstract class Card { // card type blueprint
  final String name;
  final String color;
  final CardType type; // type associate with the card
  final String image;

  Card({
    required this.name,
    required this.color,
    required this.type,
    required this.image,
  });

  int calculatePoints(Player player, List<Player> allPlayers);
}

class Boba extends Card {
  final int pointValue;

  Boba({
    required super.name, // to account for the different bobas
    required super.image, //
    required this.pointValue,
  }) : super(
      color: 'red',
      type: CardType.boba
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    if (player.playedMilkFoam(this)) {
      return pointValue * 3; // points are tripled if milk foam is played before boba
    }

    return pointValue;
  }
}

class Yakult extends Card {
  final int yakultCount;  // the person with the most yakult gets more points

  Yakult({
    required super.name,
    required this.yakultCount,
  }) : super(
    color: 'pink',
    type: CardType.yakult,
    image: 'assets/${yakultCount}yakult-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    // count total Yakult for each player
    List<int> yakultCounts = [];

    for (Player p in allPlayers) {
      int playerYakultCount = p.getYakultCount();
      yakultCounts.add(playerYakultCount);
    }

    // find the player index in the list
    int playerIndex = allPlayers.indexOf(player);

    // create a copy to find highest counts
    List<int> sortedCounts = List.from(yakultCounts);
    sortedCounts.sort((a, b) => b.compareTo(a)); // Sort descending

    // determine if player has most or second most
    if (yakultCounts[playerIndex] == sortedCounts[0]) {
      // player has the most (or tied for most)
      int tiedForFirst = sortedCounts.where((count) => count == sortedCounts[0]).length;
      if (tiedForFirst > 1) {
        // tied for first - split the points
        return 6 ~/ tiedForFirst;
      } else {
        // clearly in first place
        return 6;
      }
    } else if (yakultCounts[playerIndex] == sortedCounts[1]) {
      // player has second most (or tied for second)
      int tiedForSecond = sortedCounts.where((count) => count == sortedCounts[1]).length;
      if (tiedForSecond > 1) {
        // tied for second - split the points
        return 3 ~/ tiedForSecond;
      } else {
        // clearly in second place
        return 3;
      }
    }

    return 0; // neither first nor second
  }
}

class MilkFoam extends Card {
  // grants x3 points if played before Boba card
  MilkFoam() : super(
    name: 'Milk Foam',
    color: 'cream',
    type: CardType.special,
    image: 'assets/milkfoam-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    return 0; // no points when played on its own
  }
}

class Straw extends Card {
  Straw() : super(
    name: 'Straw',
    color: 'blue',
    type: CardType.special,
    image: 'assets/straw-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    // if you have the most different colored cards at the end of the round, +4
    List<int> uniqueColorCounts = [];

    for (Player p in allPlayers) {
      // get unique colors for this player
      Set<String> uniqueColors = {};
      for (Card c in p.playedCards) {
        uniqueColors.add(c.color);
      }
      uniqueColorCounts.add(uniqueColors.length);
    }

    // find the player index in the list
    int playerIndex = allPlayers.indexOf(player);

    // check if this player has the most unique colors
    int playerColorCount = uniqueColorCounts[playerIndex];
    int maxColorCount = uniqueColorCounts.reduce(math.max);

    if (playerColorCount == maxColorCount) {
      // count how many players tie for most colors
      int playersWithMaxColors = uniqueColorCounts.where((count) => count == maxColorCount).length;

      if (playersWithMaxColors > 1) {
        // tied for most colors - split points
        return 4 ~/ playersWithMaxColors;
      } else {
        // clear winner
        return 4;
      }
    }

    return 0; // not the most colors
  }
}

class MatchaLatte extends Card {
  // store shake score for this card instance
  int shakeScore = 0;

  MatchaLatte() : super(
    name: 'Matcha Latte',
    color: 'green',
    type: CardType.appetizer,
    image: 'assets/matchalatte-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    // count how many players played ML this round
    int matchaPlayersCount = 0;
    List<Player> matchaPlayers = [];

    for (Player p in allPlayers) {
      bool playedMatcha = p.playedCards.any((card) => card is MatchaLatte);
      if (playedMatcha) {
        matchaPlayersCount++;
        matchaPlayers.add(p);
      }
    }

    // if only one player played ML, award 3 points automatically
    if (matchaPlayersCount == 1) {
      return 3;
    }
    // if multiple players, check shake scores (which should be set during gameplay)
    else if (matchaPlayersCount > 1) {
      return shakeScore;
    }

    return 0;
  }
}

class MochiDonut extends Card {
  MochiDonut() : super(
    name: 'Mochi Donut',
    color: 'dark brown',
    type: CardType.dessert,
    image: 'assets/mochidonut-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    // only calculate during end-of-game scoring
    // count dessert cards for each player
    List<int> dessertCounts = [];

    for (Player p in allPlayers) {
      int count = p.playedCards
          .where((card) => card.type == CardType.dessert)
          .length;
      dessertCounts.add(count);
    }

    // Find the player index in the list
    int playerIndex = allPlayers.indexOf(player);

    // find max and min counts
    int maxCount = dessertCounts.reduce(math.max);
    int minCount = dessertCounts.reduce(math.min);

    // check if player has most or least desserts
    if (dessertCounts[playerIndex] == maxCount) {
      // check for ties
      int playersWithMax = dessertCounts
          .where((count) => count == maxCount)
          .length;
      if (playersWithMax > 1) {
        // tied for most - split points
        return 6 ~/ playersWithMax;
      }
      return 6;
    }
    else if (dessertCounts[playerIndex] == minCount) {
      int playersWithMin = dessertCounts
          .where((count) => count == minCount)
          .length;
      if (playersWithMin > 1) {
        return -6 ~/ playersWithMin;
      }
      return -6;
    }
    return 0;
  }
}

class CoconutJelly extends Card {
  CoconutJelly() : super(
    name: 'Coconut Jelly',
    color: 'white',
    type: CardType.appetizer,
    image: 'assets/cocojelly-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    int jellyCount = player.playedCards.whereType<CoconutJelly>().length;

    int completeSets = jellyCount ~/ 3;
    if (completeSets > 0) {
      return 10 * completeSets;
    }
    return 0;
  }
}

class PoppingBoba extends Card {
  PoppingBoba() : super(
    name: 'Popping Boba',
    color: 'light purple',
    type: CardType.appetizer,
    image: 'assets/popboba-card.png',
  );

  @override
  int calculatePoints(Player player, List<Player> allPlayers) {
    // +0 points if you have an odd number of popping boba
    // +1 points each if you have an even number
    int bobaCount = player.playedCards.whereType<PoppingBoba>().length;

    if (bobaCount % 2 == 0 && bobaCount > 0) {
      return bobaCount;
    } else {
      return 0;
    }
  }
}