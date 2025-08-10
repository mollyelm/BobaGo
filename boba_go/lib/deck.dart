import 'package:boba_go/cards.dart';

class Deck {
  List<Card> cards = [];

  Deck() {
    _initializeCards();
  }

  void _initializeCards() {

    cards.addAll([
      // boba
      for (var i = 0; i < 5; i++) Boba(name: 'Brown Sugar Milk Tea', image: 'assets/bsmt-card.png', pointValue: 3),
      for (var i = 0; i < 10; i++) Boba(name: 'Thai Tea', image: 'assets/tt-card.png', pointValue: 2),
      for (var i = 0; i < 5; i++) Boba(name: 'Taro Milk Tea', image: 'assets/tmt-card.png', pointValue: 1),

      // yakult
      for (var i = 0; i < 12; i++) Yakult(name: 'Two Yakult', yakultCount: 2),
      for (var i = 0; i < 8; i++) Yakult(name: 'Three Yakult', yakultCount: 3),
      for (var i = 0; i < 6; i++) Yakult(name: 'One Yakult', yakultCount: 1),

      // appetizers
      for (var i = 0; i < 14; i++) MatchaLatte(),
      for (var i = 0; i < 14; i++) CoconutJelly(),
      for (var i = 0; i < 14; i++) PoppingBoba(),

      // specials
      for (var i = 0; i < 4; i++) Straw(),
      for (var i = 0; i < 6; i++) MilkFoam(),

      // dessert
      for (var i = 0; i < 10; i++) MochiDonut(),
    ]);
  }

  void shuffle() {
    cards.shuffle();
  }

// List<Card> dealHand(int handSize) {
//
// }
}