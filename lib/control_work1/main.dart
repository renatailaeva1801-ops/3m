import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class CardModel {
  String color;
  bool isOpened;

  CardModel({
    required this.color,
    this.isOpened = false,
  });
}

class GameState {
  final List<CardModel> cards;
  final int errorsCount;
  final String text;

  GameState({
    required this.cards,
    required this.errorsCount,
    required this.text,
  });
}

class GameCubit extends Cubit<GameState> {
  int? firstCardIndex;

  GameCubit() : super(GameState(cards: [], errorsCount: 0, text: '')) {
    startGame();
  }

  void startGame() {
    firstCardIndex = null;

    List<CardModel> myCards = [
      CardModel(color: 'blue'),
      CardModel(color: 'red'),
      CardModel(color: 'blue'),
      CardModel(color: 'red'),
    ];

    myCards.shuffle();

    emit(GameState(cards: myCards, errorsCount: 0, text: ''));
  }

  void onCardTap(int index) async {
    if (state.cards[index].isOpened || state.text == 'У вас не осталось попыток') {
      return;
    }

    state.cards[index].isOpened = true;
    emit(GameState(cards: state.cards, errorsCount: state.errorsCount, text: state.text));

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      int first = firstCardIndex!;
      int second = index;

      if (state.cards[first].color == state.cards[second].color) {
        firstCardIndex = null;
        emit(GameState(cards: state.cards, errorsCount: state.errorsCount, text: 'Успешно'));
      } else {
        int newErrors = state.errorsCount + 1;

        await Future.delayed(const Duration(milliseconds: 500));

        if (newErrors >= 1) {
          emit(GameState(
            cards: state.cards,
            errorsCount: newErrors,
            text: 'У вас не осталось попыток',
          ));
        } else {
          state.cards[first].isOpened = false;
          state.cards[second].isOpened = false;
          firstCardIndex = null;

          emit(GameState(cards: state.cards, errorsCount: newErrors, text: ''));
        }
      }
    }
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  Color getColor(String colorName) {
    if (colorName == 'blue') return Colors.blue;
    if (colorName == 'red') return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Найти пару',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Количество ошибочных попыток: ${state.errorsCount}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  if (state.cards.length == 4) ...[
                    Row(
                      children: [
                        Expanded(child: buildCard(context, state.cards[0], 0)),
                        const SizedBox(width: 10),
                        Expanded(child: buildCard(context, state.cards[1], 1)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: buildCard(context, state.cards[2], 2)),
                        const SizedBox(width: 10),
                        Expanded(child: buildCard(context, state.cards[3], 3)),
                      ],
                    ),
                  ],

                  const Spacer(),

                  if (state.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        state.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<GameCubit>().startGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Начать заново',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, CardModel card, int index) {
    return GestureDetector(
      onTap: () {
        context.read<GameCubit>().onCardTap(index);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: card.isOpened ? getColor(card.color) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}