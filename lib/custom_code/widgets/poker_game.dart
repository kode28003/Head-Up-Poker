// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

class PokerGame extends StatefulWidget {
  const PokerGame({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<PokerGame> createState() => _PokerGameState();
}

class _PokerGameState extends State<PokerGame>
    with SingleTickerProviderStateMixin {
  List<String> deck = [];
  List<String> player1Hand = [];
  List<String> player2Hand = [];
  List<String> board = [];
  List<String> highlightedCards = [];
  String result = "";
  String player1HandRank = "";
  String player2HandRank = "";
  List<String> hightLightCard_player1_board = [];
  List<String> hightLightCard_player2_board = [];

  bool cardsDealt = false;
  bool boardRevealed = false;
  bool finalBoardRevealed = false;
  bool tapping = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    //startGame();
  }

  // Map<int, String> handRankings = {
  //   10: "ロイヤルフラッシュ",
  //   9: "ストレートフラッシュ",
  //   8: "フォーカード",
  //   7: "フルハウス",
  //   6: "フラッシュ",
  //   5: "ストレート",
  //   4: "スリーカード",
  //   3: "ツーペア",
  //   2: "ワンペア",
  //   1: "ハイカード"
  // };
  Map<int, String> handRankings = {
    10: "Royal Flush",
    9: "Straight Flush",
    8: "Four Card",
    7: "Full House",
    6: "Flush",
    5: "Straight",
    4: "Three Card",
    3: "Two Pair",
    2: "One Pair",
    1: "High Card"
  };

  List<String> createDeck() {
    List<String> suits = ['H', 'D', 'C', 'S'];
    List<String> ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
      'A'
    ];
    return [
      for (var suit in suits)
        for (var rank in ranks) '$rank$suit'
    ]..shuffle(Random());
  }

  void dealCards() {
    player1Hand = [deck.removeAt(0), deck.removeAt(0)];
    player2Hand = [deck.removeAt(0), deck.removeAt(0)];
    setState(() => cardsDealt = true);

    // 3枚の場のカードを最初にオープン
    Future.delayed(Duration(seconds: 2), () {
      board = [for (int i = 0; i < 3; i++) deck.removeAt(0)];
      setState(() => boardRevealed = true);
    });

    // 4枚目のカードを1秒後にオープン
    Future.delayed(Duration(seconds: 3), () {
      board.add(deck.removeAt(0));
      setState(() => finalBoardRevealed = true);
    });

    // 5枚目のカードをさらに1秒後にオープン
    Future.delayed(Duration(seconds: 4), () {
      board.add(deck.removeAt(0));
      setState(() => finalBoardRevealed = true);
    });
  }

  void evaluateHandAndHighlight(List<String> hand) {
    List<String> ranks =
        hand.map((card) => card.substring(0, card.length - 1)).toList();
    List<String> suits =
        hand.map((card) => card.substring(card.length - 1)).toList();

    List<int> rankValues = ranks.map((rank) {
      if (rank == 'A') return 14;
      if (rank == 'K') return 13;
      if (rank == 'Q') return 12;
      if (rank == 'J') return 11;
      return int.parse(rank);
    }).toList();

    rankValues.sort();

    Map<String, int> suitCount = {};
    for (var suit in suits) {
      suitCount[suit] = (suitCount[suit] ?? 0) + 1;
    }

    Map<int, int> rankCount = {};
    for (var rank in rankValues) {
      rankCount[rank] = (rankCount[rank] ?? 0) + 1;
    }

    highlightedCards.clear(); // ハイライトリストをクリア

    // ストレートの確認
    bool isStraight = false;
    if (rankValues.length == 5) {
      if (rankValues[4] - rankValues[0] == 4) {
        isStraight = true;
        highlightedCards.addAll(hand); // ストレートに関連するカードをハイライト
      } else if (rankValues.contains(14) &&
          rankValues[1] == 2 &&
          rankValues[2] == 3 &&
          rankValues[3] == 4 &&
          rankValues[4] == 5) {
        isStraight = true;
        highlightedCards.addAll(hand); // Ace lowストレートに関連するカードをハイライト
      }
    }

    // フラッシュの確認
    bool isFlush = suitCount.values.any((count) => count >= 5);
    if (isFlush) {
      highlightedCards.addAll(hand); // フラッシュに関連するカードをハイライト
    }

    // フルハウス、スリーカード、ペアの確認
    bool isFullHouse = rankCount.containsValue(3) && rankCount.containsValue(2);
    bool isThreeOfAKind = rankCount.containsValue(3);
    bool isPair = rankCount.containsValue(2);

    if (isFullHouse) {
      highlightedCards.addAll(hand); // フルハウスに関連するカードをハイライト
    } else if (isThreeOfAKind) {
      highlightedCards.addAll(hand); // スリーカードに関連するカードをハイライト
    } else if (isPair) {
      highlightedCards.addAll(hand); // ペアに関連するカードをハイライト
    }

    // その他の役の確認（フォーカード、ストレートフラッシュなど）
    bool isFourOfAKind = rankCount.containsValue(4);
    bool isStraightFlush = isStraight && isFlush;

    if (isFourOfAKind) {
      highlightedCards.addAll(hand); // フォーカードに関連するカードをハイライト
    } else if (isStraightFlush) {
      highlightedCards.addAll(hand); // ストレートフラッシュに関連するカードをハイライト
    }
  }

  int pokerRank(List<String> hand, List<String> board, int playerNum) {
    bool flush = false;
    bool straight = false;
    //String rank = '';
    int rankValue = 0;
    List<int> cardPower = [];

    // handとboardからランクとスートを抽出
    List<String> ranks = [
      ...hand.map((card) => card.substring(0, card.length - 1)),
      ...board.map((card) => card.substring(0, card.length - 1))
    ];
    List<String> suits = [
      ...hand.map((card) => card.substring(card.length - 1)),
      ...board.map((card) => card.substring(card.length - 1))
    ];

    List<int> numList = List.generate(15, (index) => 0); // 数字のカウント
    List<int> suitList = List.generate(5, (index) => 0); // スートのカウント

    // ランクとスートのカウント
    for (int i = 0; i < ranks.length; i++) {
      int rankValue = _cardRankValue(ranks[i]);
      int suitValue = _cardSuitValue(suits[i]);

      numList[rankValue] += 1;
      suitList[suitValue] += 1;
    }

    // フラッシュの判定
    if (suitList.contains(5)) {
      flush = true;
    }

    // ストレートの判定
    List<int> straightNumList = List.from(numList);
    for (int i = 2; i <= 10; i++) {
      if (straightNumList[i] == 1) {
        for (int j = 0; j < 4; j++) {
          if (straightNumList[i + j + 1] == 0) {
            if (straightNumList[0] >= 1) {
              straightNumList[i + j + 1] += 1;
              straightNumList[0] -= 1;
            } else {
              break;
            }
          }
          if (j + 1 == 4) {
            straight = true;
          }
        }
        break;
      }
    }

    // 役の判定
    if (numList.contains(5)) {
      //rank = 'five of a kind';
      cardPower.add(10);
      cardPower.add(numList.indexOf(5));
      rankValue = 10;
    } else if (flush && straight) {
      // rank = 'straight flush';
      cardPower.add(8);
      rankValue = 9;
    } else if (numList.contains(4)) {
      //rank = 'four of a kind';
      cardPower.add(7);
      rankValue = 8;
    } else if (numList.contains(3) && numList.contains(2)) {
      //rank = 'full house';
      cardPower.add(6);
      rankValue = 7;
    } else if (flush) {
      //rank = 'flush';
      cardPower.add(5);
      rankValue = 6;
    } else if (straight) {
      // rank = 'straight';
      cardPower.add(4);
      rankValue = 5;
    } else if (numList.contains(3)) {
      //rank = 'three of a kind';
      cardPower.add(3);
      rankValue = 4;
    } else if (numList.where((x) => x == 2).length == 2) {
      // rank = 'two pair';
      cardPower.add(2);
      rankValue = 3;
    } else if (numList.contains(2)) {
      // rank = 'a pair';
      cardPower.add(1);
      rankValue = 2;
    } else {
      // rank = 'high card';
      cardPower.add(0);
      rankValue = 1;
    }

    while (cardPower.length < 6) {
      cardPower.add(0);
    }
    findBestHand(hand, board, playerNum);
    return rankValue;
  }

  int _cardRankValue(String rank) {
    const rankMap = {
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
      '6': 6,
      '7': 7,
      '8': 8,
      '9': 9,
      '10': 10,
      'J': 11,
      'Q': 12,
      'K': 13,
      'A': 14
    };
    return rankMap[rank] ?? 0;
  }

  int _cardSuitValue(String suit) {
    const suitMap = {'H': 1, 'D': 2, 'C': 3, 'S': 4};
    return suitMap[suit] ?? 0;
  }

  void findBestHand(List<String> hand, List<String> board, int playerNum) {
    List<String> combined = [...hand, ...board];
    List<List<String>> possibleHands = [];

    // 7 枚のカードから 5 枚を選ぶ全組み合わせを生成
    for (int i = 0; i < combined.length; i++) {
      for (int j = i + 1; j < combined.length; j++) {
        List<String> selectedHand = List.from(combined);
        selectedHand.removeAt(j);
        selectedHand.removeAt(i);
        possibleHands.add(selectedHand);
      }
    }

    int bestRank = 0;
    List<String> bestHand = [];

    for (List<String> h in possibleHands) {
      int currentRank = pokerRank(h, [], playerNum);
      if (currentRank > bestRank) {
        bestRank = currentRank;
        bestHand = List.from(h);
      }
    }

    if (playerNum == 1) {
      if (bestRank == 9) {
        // ストレートフラッシュ
        hightLightCard_player1_board = bestHand; // 5枚のストレートフラッシュカード
      } else if (bestRank == 8) {
        // フォーカード
        List<String> fourOfAKindCards = _getFourOfAKindCards(bestHand);
        hightLightCard_player1_board = fourOfAKindCards;
      } else if (bestRank == 7) {
        // フルハウス
        List<String> fullHouseCards = _getFullHouseCards(bestHand);
        hightLightCard_player1_board = fullHouseCards;
      } else if (bestRank == 6) {
        // フラッシュ
        List<String> flushCards = _getFlushCards(bestHand);
        hightLightCard_player1_board = flushCards;
      } else if (bestRank == 5) {
        // ストレート
        List<String> straightCards = _getStraightCards(bestHand);
        hightLightCard_player1_board = straightCards;
      } else if (bestRank == 4) {
        // スリーカード
        List<String> threeOfAKindCards = _getThreeOfAKindCards(bestHand);
        hightLightCard_player1_board = threeOfAKindCards;
      } else if (bestRank == 3) {
        // ツーペア
        List<String> twoPairCards = _getTwoPairCards(bestHand);
        hightLightCard_player1_board = twoPairCards;
      } else if (bestRank == 2) {
        // ワンペア
        List<String> onePairCards = _getOnePairCards(bestHand);
        hightLightCard_player1_board = onePairCards;
      } else {
        // ハイカード
        if (bestHand.isNotEmpty) {
          // bestHandが空でないかチェック
          hightLightCard_player1_board = [bestHand[0]]; // 最高のハイカード
        } else {
          hightLightCard_player1_board = []; // bestHandが空の場合、空のリストを設定
        }
      }
    } else {
      if (bestRank == 9) {
        // ストレートフラッシュ
        hightLightCard_player2_board = bestHand; // 5枚のストレートフラッシュカード
      } else if (bestRank == 8) {
        // フォーカード
        List<String> fourOfAKindCards = _getFourOfAKindCards(bestHand);
        hightLightCard_player2_board = fourOfAKindCards;
      } else if (bestRank == 7) {
        // フルハウス
        List<String> fullHouseCards = _getFullHouseCards(bestHand);
        hightLightCard_player2_board = fullHouseCards;
      } else if (bestRank == 6) {
        // フラッシュ
        List<String> flushCards = _getFlushCards(bestHand);
        hightLightCard_player2_board = flushCards;
      } else if (bestRank == 5) {
        // ストレート
        List<String> straightCards = _getStraightCards(bestHand);
        hightLightCard_player2_board = straightCards;
      } else if (bestRank == 4) {
        // スリーカード
        List<String> threeOfAKindCards = _getThreeOfAKindCards(bestHand);
        hightLightCard_player2_board = threeOfAKindCards;
      } else if (bestRank == 3) {
        // ツーペア
        List<String> twoPairCards = _getTwoPairCards(bestHand);
        hightLightCard_player2_board = twoPairCards;
      } else if (bestRank == 2) {
        // ワンペア
        List<String> onePairCards = _getOnePairCards(bestHand);
        hightLightCard_player2_board = onePairCards;
      } else {
        // ハイカード
        if (bestHand.isNotEmpty) {
          // bestHandが空でないかチェック
          hightLightCard_player2_board = [bestHand[0]]; // 最高のハイカード
        } else {
          hightLightCard_player2_board = []; // bestHandが空の場合、空のリストを設定
        }
      }
    }
  }
//

  List<String> _getFourOfAKindCards(List<String> hand) {
    // フォーカードに該当するカードを抽出
    List<String> fourOfAKindCards = [];
    Map<String, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      if (!rankMap.containsKey(rank)) {
        rankMap[rank] = [];
      }
      rankMap[rank]!.add(card);
    }

    rankMap.forEach((rank, cards) {
      if (cards.length == 4) {
        fourOfAKindCards.addAll(cards); // 4枚のカードを追加
      }
    });

    return fourOfAKindCards;
  }

  List<String> _getThreeOfAKindCards(List<String> hand) {
    // スリーカードに該当するカードを抽出
    List<String> threeOfAKindCards = [];
    Map<String, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      if (!rankMap.containsKey(rank)) {
        rankMap[rank] = [];
      }
      rankMap[rank]!.add(card);
    }

    rankMap.forEach((rank, cards) {
      if (cards.length == 3) {
        threeOfAKindCards.addAll(cards); // 3枚のカードを追加
      }
    });

    return threeOfAKindCards;
  }

  List<String> _getStraightCards(List<String> hand) {
    // ストレートに該当するカードを抽出
    List<String> straightCards = [];
    Map<int, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      int rankValue = _cardRankValue(rank);
      if (!rankMap.containsKey(rankValue)) {
        rankMap[rankValue] = [];
      }
      rankMap[rankValue]!.add(card);
    }

    List<int> sortedRanks = rankMap.keys.toList()..sort();

    // ストレートに該当するカードを探す
    for (int i = 0; i <= sortedRanks.length - 5; i++) {
      if (sortedRanks[i + 4] - sortedRanks[i] == 4) {
        // ストレート成立
        for (int j = 0; j < 5; j++) {
          straightCards.addAll(rankMap[sortedRanks[i + j]]!);
        }
        break;
      }
    }

    return straightCards;
  }

  List<String> _getFullHouseCards(List<String> hand) {
    // フルハウスに該当するカードを抽出
    List<String> fullHouseCards = [];
    Map<String, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      if (!rankMap.containsKey(rank)) {
        rankMap[rank] = [];
      }
      rankMap[rank]!.add(card);
    }

    rankMap.forEach((rank, cards) {
      if (cards.length == 3) {
        fullHouseCards.addAll(cards); // スリーカード
      }
      if (cards.length == 2) {
        fullHouseCards.addAll(cards); // ペア
      }
    });

    return fullHouseCards;
  }

  List<String> _getFlushCards(List<String> hand) {
    // フラッシュに該当するカードを抽出
    List<String> flushCards = [];
    Map<String, List<String>> suitMap = {};

    for (var card in hand) {
      String suit = card.substring(card.length - 1); // スート部分を取得
      if (!suitMap.containsKey(suit)) {
        suitMap[suit] = [];
      }
      suitMap[suit]!.add(card);
    }

    suitMap.forEach((suit, cards) {
      if (cards.length >= 5) {
        flushCards.addAll(cards.take(5)); // フラッシュに該当するカード
      }
    });

    return flushCards;
  }

  List<String> _getTwoPairCards(List<String> hand) {
    // ツーペアに該当するカードを抽出
    List<String> twoPairCards = [];
    Map<String, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      if (!rankMap.containsKey(rank)) {
        rankMap[rank] = [];
      }
      rankMap[rank]!.add(card);
    }

    rankMap.forEach((rank, cards) {
      if (cards.length == 2) {
        twoPairCards.addAll(cards); // ペアを追加
      }
    });

    return twoPairCards;
  }

  List<String> _getOnePairCards(List<String> hand) {
    // ワンペアに該当するカードを抽出
    List<String> onePairCards = [];
    Map<String, List<String>> rankMap = {};

    for (var card in hand) {
      String rank = card.substring(0, card.length - 1); // ランク部分を取得
      if (!rankMap.containsKey(rank)) {
        rankMap[rank] = [];
      }
      rankMap[rank]!.add(card);
    }

    rankMap.forEach((rank, cards) {
      if (cards.length == 2) {
        onePairCards.addAll(cards); // ペアを追加
      }
    });

    return onePairCards;
  }

  void startGame() {
    if (tapping == false) {
      setState(() {
        tapping = true;
        player1Hand.clear();
        player2Hand.clear();
        player1HandRank = "";
        player2HandRank = "";
        highlightedCards = [];
        deck = createDeck();
        board.clear();
        result = "";
        cardsDealt = false;
        boardRevealed = false;
        finalBoardRevealed = false;
      });
      _controller.forward(from: 0);

      dealCards();
      Future.delayed(Duration(seconds: 6), () {
        determineWinner();
        tapping = false;
      });
    } else {}
  }

  void determineWinner() {
    // int score1 = evaluateHand([...player1Hand, ...board]);
    // int score2 = evaluateHand([...player2Hand, ...board]);
    int score1 = pokerRank(player1Hand, board, 1);
    int score2 = pokerRank(player2Hand, board, 2);

    player1HandRank = handRankings[score1] ?? "";
    player2HandRank = handRankings[score2] ?? "";
    // evaluateHandAndHighlight([...player1Hand, ...board]);
    // evaluateHandAndHighlight([...player2Hand, ...board]);
    if (score1 > score2) {
      highlightedCards = hightLightCard_player1_board;
    } else {
      highlightedCards = hightLightCard_player2_board;
    }

    setState(() {
      // result = score1 > score2
      //     ? 'Player1 Wins!'
      //     : score1 < score2
      //         ? 'Player2 Wins!'
      //         : 'Draw!';
      if (score1 > score2) {
        result = 'Player1 Wins!';
      } else if (score1 < score2) {
        result = 'Player2 Wins!';
      } else {
        highlightedCards = [];
        result = 'Draw!';
      }
    });
  }

  Widget cardWidget(String? card, bool revealed, bool highlight) {
    if (card == null) return SizedBox(width: 50, height: 75);

    String suit = card.substring(card.length - 1);
    String rank = card.substring(0, card.length - 1);

    Map<String, String> suitMap = {
      'S': 'spade',
      'H': 'heart',
      'D': 'diamond',
      'C': 'club',
    };

    String suitName = suitMap[suit] ?? 'unknown';
    String imageName = 'assets/images/${suitName}_$rank.png';

    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: revealed ? 1.0 : 0.0,
      child: Container(
        decoration: highlight
            ? BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 4),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Image.asset(
          revealed ? imageName : 'assets/images/back.png',
          width: 50,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading image: $imageName");
            return Container(
              width: 50,
              height: 75,
              color: Colors.red,
              child: Center(child: Icon(Icons.error, color: Colors.white)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // プレイヤー1の手札と番号表示
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                child: Text(
                  'Player1 : $player1HandRank',
                  style: TextStyle(
                      fontSize: 20,
                      color: result == 'Player1 Wins!'
                          ? Colors.yellow
                          : Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  bool isHighlighted1 = false;

                  if (index >= 0 && index < player1Hand.length) {
                    isHighlighted1 =
                        highlightedCards.contains(player1Hand[index]);
                  }

                  return SizedBox(
                    width: 70,
                    height: 98,
                    child: index < player1Hand.length
                        ? cardWidget(
                            player1Hand[index], cardsDealt, isHighlighted1)
                        : Container(),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 20),
          // ボードカード表示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              bool isHighlighted2 = false;

              if (index >= 0 && index < board.length) {
                isHighlighted2 = highlightedCards.contains(board[index]);
              }
              return AnimatedOpacity(
                duration: Duration(milliseconds: 500 * (index + 1)),
                opacity: index < board.length ? 1.0 : 0.0,
                child: SizedBox(
                  width: 70, //50
                  height: 98, //70
                  child: index < board.length
                      ? cardWidget(board[index], boardRevealed, isHighlighted2)
                      : Container(),
                ),
              );
            }),
          ),
          SizedBox(height: 20),

          // プレイヤー2の手札と番号表示
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  bool isHighlighted3 = false;

                  if (index >= 0 && index < player2Hand.length) {
                    isHighlighted3 =
                        highlightedCards.contains(player2Hand[index]);
                  }
                  return SizedBox(
                    width: 70,
                    height: 98,
                    child: index < player2Hand.length
                        ? cardWidget(
                            player2Hand[index], cardsDealt, isHighlighted3)
                        : Container(),
                  );
                }),
              ),
              SizedBox(height: 10),
              Text(
                'Player2 : $player2HandRank',
                style: TextStyle(
                    fontSize: 20,
                    color: result == 'Player2 Wins!'
                        ? Colors.yellow
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: startGame,
            child: Text('Play'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(120, 40),
            ),
          ),
          // 結果表示

          SizedBox(height: 40),
          Text(
            result,
            style: TextStyle(
                fontSize: 26,
                color: Colors.yellow,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
