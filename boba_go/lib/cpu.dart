import 'dart:collection';
import 'dart:math';
import 'package:boba_go/player.dart';
import 'package:boba_go/cards.dart';
import 'package:boba_go/main.dart';
import 'package:flutter/cupertino.dart';


class CPU extends Player {
  static int cpuCount = 0;
  bool lastPlayedCardIsMilkFoam = false;

  CPU() : super(name: 'CPU${++cpuCount}');

  Card chooseCard() {
    Set<String> cardsToChooseFrom = HashSet();
    Map<String, List<int>> cardWeight = HashMap();
    int totalWeight = 0;


    for (Card c in hand) {
      cardsToChooseFrom.add(c.name);
    }

    switch (GamePanel.turnNumber) {
      case 1:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              weight = 8;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Straw":
              weight = 1;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 2;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              weight = 2;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              weight = 2;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Taro Milk Tea":
              weight = 1;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Three Yakult":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              weight = 2;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "One Yakult":
              weight = 1;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
          }
        }
      case 2:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 8;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];

              }
            case "Straw":
              weight = 1;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 2;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3*(numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 4; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 3:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 7;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];

              }
            case "Straw":
              weight = 1 + getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3*(numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 3; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 4:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 6;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Straw":
              weight = 1 + getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3*(numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 3; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 5:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 5;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Straw":
              weight = 1 + getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 5;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3 * (numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1
                  ? 4 * numPopping
                  : 2; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 6:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Straw":
              weight = 1 + 2*getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 5;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3*(numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 2; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 4;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 7:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              if (!lastPlayedCardIsMilkFoam) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Straw":
              weight = 1 + 2*getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 6;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = 3 + 3*(numCoconuts % 3);
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 1; // if numPopping is odd, prioritize popping boba
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 2;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 5;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
      case 8:
        for (String s in cardsToChooseFrom) {
          int startWeight;
          int weight;
          switch (s) {
            case "Milk Foam":
              break;
            case "Straw":
              weight = 1 + 3*getNumColors();
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Matcha Latte":
              weight = 1;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Mochi Donut":
              weight = 7;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Coconut Jelly":
              int numCoconuts = 0;
              for (Card c in playedCards) {
                if (c is CoconutJelly) {
                  numCoconuts++;
                }
              }
              weight = numCoconuts % 3 == 2 ? 10 : 3;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Popping Boba":
              int numPopping = 0;
              for (Card c in playedCards) {
                if (c is PoppingBoba) {
                  numPopping++;
                }
              }
              weight = numPopping % 2 == 1 ? 4*numPopping : 0; // if numPopping is odd, prioritize popping boba
              if (weight != 0) {
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }

            case "Brown Sugar Milk Tea":
              if (lastPlayedCardIsMilkFoam) {
                weight = 30;
              } else {
                weight = 3;
              }
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Thai Tea":
              if (!hasBetterBoba("Thai Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 20;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Taro Milk Tea":
              if (!hasBetterBoba("Taro Milk Tea")) {
                if (lastPlayedCardIsMilkFoam) {
                  weight = 10;
                } else {
                  weight = 1;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "Three Yakult":
              weight = 5;
              startWeight = totalWeight;
              totalWeight += weight;
              cardWeight[s] = [startWeight, totalWeight];
            case "Two Yakult":
              if (!hasBetterYakult("Two Yakult")) {
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
            case "One Yakult":
              if (!hasBetterYakult("One Yakult")) {
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              }
          }
        }
    }

    int choice = Random().nextInt(totalWeight) + 1;
    String selectedCard = "";

    if (totalWeight == 0) {
      return hand[0];
    }
    for (MapEntry<String, List<int>> cardWeights in cardWeight.entries) {
      if (cardWeights.value[0] <= choice && cardWeights.value[1] >= choice) {
        selectedCard = cardWeights.key;
      }
    }
    for (Card c in hand) {
      if (c.name == selectedCard) {
        if (c.name == "Milk Foam") {
          lastPlayedCardIsMilkFoam = true;
        }
        return c;
      }
    }
    throw Error();
  }

  bool hasBetterBoba(String boba) { // checks if there's a boba worth more in your hand
    bool hasBetterBoba = false;
    if (boba == "Thai Tea") {
      for (Card c in hand) {
        if (c is Boba && c.name == "Brown Sugar Milk Tea") {
          hasBetterBoba = true;
          break;
        }
      }
    } else if (boba == "Taro Milk Tea") {
      for (Card c in hand) {
        if (c is Boba && (c.name == "Brown Sugar Milk Tea" || c.name == "Thai Tea")) {
          hasBetterBoba = true;
          break;
        }
      }
    }
    return hasBetterBoba;
  }

  bool hasBetterYakult(String yakult) {
    bool hasBetterYakult = false;
    if (yakult == "Two Yakult") {
      for (Card c in hand) {
        if (c is Yakult && c.name == "Three Yakult") {
          hasBetterYakult = true;
          break;
        }
      }
    } else if (yakult == "One Yakult") {
      for (Card c in hand) {
        if (c is Yakult && (c.name == "Three Yakult" || c.name == "Two Yakult")) {
          hasBetterYakult = true;
          break;
        }
      }
    }
    return hasBetterYakult;
  }

  int getNumColors() {
    Set<String> colors = HashSet<String>();
    for (Card c in playedCards) {
      colors.add(c.color);
    }
    return colors.length;
  }

  int getNumColorsInHand(List<Card> hand) {
    Set<String> colors = HashSet<String>();
    for (Card c in hand) {
      colors.add(c.color);
    }
    return colors.length;
  }

  List<List<Card>> otherHands = [];

  Card smartChooseCard() {
    {
      Set<String> cardsToChooseFrom = HashSet();
      Map<String, List<int>> cardWeight = HashMap();
      int totalWeight = 0;


      for (Card c in hand) {
        cardsToChooseFrom.add(c.name);
      }

      switch (GamePanel.turnNumber) {
        case 1:
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                weight = 8;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Straw":
                weight = ((1/2) * getNumColorsInHand(hand)).floor();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];

              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Popping Boba":
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Taro Milk Tea":
                weight = 1;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Three Yakult":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                weight = 2;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "One Yakult":
                weight = 1;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
            }
          }
        case 2:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                bool otherHandHasBoba = false;

                for (Card c in otherHands[otherHands.length - 1]) {
                  if (c is Boba) {
                    otherHandHasBoba = true;
                    break;
                  }
                }

                if (!lastPlayedCardIsMilkFoam && otherHandHasBoba) {
                  weight = 8;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Straw":
                weight = ((1/4) * getNumColorsInHand(hand)).floor() + ((1/4) * getNumColorsInHand(otherHands[otherHands.length - 1])).floor();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }

                weight = numPopping % 2 == 1 ? 4*numPopping : 4; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 3:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                if (!lastPlayedCardIsMilkFoam) {
                  weight = 7;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];

                }
              case "Straw":
                weight = 1 + getNumColors() + ((1/4) * getNumColorsInHand(hand)).floor() + ((1/4) * getNumColorsInHand(otherHands[otherHands.length - 1])).floor();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1 ? 4*numPopping : 3; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 4:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                if (!lastPlayedCardIsMilkFoam) {
                  weight = 6;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Straw":
                weight = 1 + getNumColors() + ((1/4) * getNumColorsInHand(hand)).floor() + ((1/4) * getNumColorsInHand(otherHands[otherHands.length - 1])).floor();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1 ? 4*numPopping : 3; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 5:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                if (!lastPlayedCardIsMilkFoam) {
                  weight = 5;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Straw":
                weight = 1 + getNumColors() + ((1/4) * getNumColorsInHand(hand)).floor() + ((1/4) * getNumColorsInHand(otherHands[otherHands.length - 1])).floor();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 5;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1
                    ? 4 * numPopping
                    : 2; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 6:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                if (!lastPlayedCardIsMilkFoam) {
                  weight = 4;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Straw":
                weight = 1 + 2*getNumColors();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 5;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1 ? 4*numPopping : 2; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 4;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 7:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                if (!lastPlayedCardIsMilkFoam) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Straw":
                weight = 1 + 2*getNumColors();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 6;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }

                int numCoconutsAvailable = 0;
                for (Card c in hand) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }
                for (Card c in otherHands[otherHands.length-1]) {
                  if (c is CoconutJelly) {
                    numCoconutsAvailable++;
                  }
                }

                if (numCoconuts + numCoconutsAvailable >= 3) {
                  weight = 3 + 3*(numCoconuts % 3);
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                } else {
                  weight = 1;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1 ? 4*numPopping : 1; // if numPopping is odd, prioritize popping boba
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 2;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 5;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
        case 8:
          if (otherHands.isEmpty) {
            return chooseCard();
          }
          for (String s in cardsToChooseFrom) {
            int startWeight;
            int weight;
            switch (s) {
              case "Milk Foam":
                break;
              case "Straw":
                weight = 1 + 3*getNumColors();
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Matcha Latte":
                weight = 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Mochi Donut":
                weight = 7;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Coconut Jelly":
                int numCoconuts = 0;
                for (Card c in playedCards) {
                  if (c is CoconutJelly) {
                    numCoconuts++;
                  }
                }
                weight = numCoconuts % 3 == 2 ? 10 : 3;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Popping Boba":
                int numPopping = 0;
                for (Card c in playedCards) {
                  if (c is PoppingBoba) {
                    numPopping++;
                  }
                }
                weight = numPopping % 2 == 1 ? 4*numPopping : 0; // if numPopping is odd, prioritize popping boba
                if (weight != 0) {
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }

              case "Brown Sugar Milk Tea":
                if (lastPlayedCardIsMilkFoam) {
                  weight = 30;
                } else {
                  weight = 3;
                }
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Thai Tea":
                if (!hasBetterBoba("Thai Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 20;
                  } else {
                    weight = 2;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Taro Milk Tea":
                if (!hasBetterBoba("Taro Milk Tea")) {
                  if (lastPlayedCardIsMilkFoam) {
                    weight = 10;
                  } else {
                    weight = 1;
                  }
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "Three Yakult":
                weight = 5;
                startWeight = totalWeight;
                totalWeight += weight;
                cardWeight[s] = [startWeight, totalWeight];
              case "Two Yakult":
                if (!hasBetterYakult("Two Yakult")) {
                  weight = 3;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
              case "One Yakult":
                if (!hasBetterYakult("One Yakult")) {
                  weight = 2;
                  startWeight = totalWeight;
                  totalWeight += weight;
                  cardWeight[s] = [startWeight, totalWeight];
                }
            }
          }
      }

      int choice = Random().nextInt(totalWeight) + 1;
      String selectedCard = "";

      if (totalWeight == 0) {
        return hand[0];
      }
      for (MapEntry<String, List<int>> cardWeights in cardWeight.entries) {
        if (cardWeights.value[0] <= choice && cardWeights.value[1] >= choice) {
          selectedCard = cardWeights.key;
        }
      }

      otherHands.add(hand);

      for (Card c in hand) {
        if (c.name == selectedCard) {
          if (c.name == "Milk Foam") {
            lastPlayedCardIsMilkFoam = true;
          }
          return c;
        }
      }

      throw Error();
    }
  }

}