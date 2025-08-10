import 'package:boba_go/cards.dart';

class Player {
  final String name;
  List<Card> hand = [];
  List<Card> playedCards = [];
  int score = 0;
  
  Player({required this.name});
  
  // idk how to do this
  // real

  // called by main.dart after double-clicking on a card in hand(?)
  // adds the card to playedCards
  // swap hands
  // Card playCard(int cardIndex) {
  //   // return;
  // }
  
  void receiveHand(List<Card> newHand) {
    hand = newHand;
  }
  
  int calculateScore(List<Player> allPlayers) {
    int roundScore = 0;
    
    for (var card in playedCards) {
      roundScore += card.calculatePoints(this, allPlayers);
    }
    
    score += roundScore;
    return roundScore;
  }
  
  bool playedMilkFoam(Card card) {
    int cardIndex = playedCards.indexOf(card);
    
    if (cardIndex <= 0) {
      return false;
    } 
    
    if (playedCards[cardIndex - 1] is MilkFoam)  {
      return true;
    }
    
    return false;
  }
  
  int getYakultCount() {
    int total = 0;

    for (var card in playedCards) {
      if (card is Yakult) {
        total += card.yakultCount;
      }
    }

    return total;
  }
  
  // int getUniqueCardColors() {
    
  // }
}