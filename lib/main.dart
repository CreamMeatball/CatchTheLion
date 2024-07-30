import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Catch the Lion!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameController(),
    );
  }
}

class GamePiece {
  String type;
  int positionX;
  int positionY;

  GamePiece(this.type, this.positionX, this.positionY);

  void move(String direction, int distance) {
    if (type == 'Lion') {
      switch (direction) {
        case 'up':
          positionY -= distance;
          break;
        case 'down':
          positionY += distance;
          break;
        case 'left':
          positionX -= distance;
          break;
        case 'right':
          positionX += distance;
          break;
      }
    } else if (type == 'Giraffe') {
      if (direction == 'up') {
        positionY -= distance;
      }
    }
  }
}

class GameBoard {
  List<List<GamePiece?>> board;

  GameBoard() {
    board = List.generate(3, (_) => List<GamePiece?>.filled(4, null));
  }

  void placePiece(GamePiece piece, int x, int y) {
    board[x][y] = piece;
  }

  GamePiece? getPiece(int x, int y) {
    return board[x][y];
  }

  bool isValidMove(GamePiece piece, String direction, int distance) {
    int newX = piece.positionX;
    int newY = piece.positionY;

    switch (direction) {
      case 'up':
        newY -= distance;
        break;
      case 'down':
        newY += distance;
        break;
      case 'left':
        newX -= distance;
        break;
      case 'right':
        newX += distance;
        break;
    }

    if (newX < 0 || newX >= board.length || newY < 0 || newY >= board[0].length) {
      return false;
    }

    if (board[newX][newY] != null) {
      return false;
    }

    return true;
  }

  bool isGameOver() {
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[0].length; y++) {
        GamePiece? piece = board[x][y];
        if (piece != null && piece.type == 'Lion') {
          if (x == 0) {
            return true;
          }
          return false;
        }
      }
    }
    return true;
  }
}

class GamePieceWidget extends StatelessWidget {
  final GamePiece piece;

  GamePieceWidget({required this.piece, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: piece.type == 'Lion' ? Colors.yellow : Colors.brown,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          piece.type,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class GameBoardWidget extends StatelessWidget {
  final GameBoard board;

  GameBoardWidget({required this.board, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        int x = index ~/ 4;
        int y = index % 4;
        GamePiece? piece = board.getPiece(x, y);
        return piece != null ? GamePieceWidget(piece: piece) : Container();
      },
    );
  }
}

class GameController extends StatefulWidget {
  const GameController({Key? key}) : super(key: key);

  @override
  _GameControllerState createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
  late GameBoard board;

  @override
  void initState() {
    super.initState();
    board = GameBoard();

    // Add initial game pieces here
    GamePiece lion = GamePiece('Lion', 1, 1);
    GamePiece giraffe = GamePiece('Giraffe', 2, 2);

    board.placePiece(lion, 1, 1);
    board.placePiece(giraffe, 2, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Catch the Lion!'),
      ),
      body: GameBoardWidget(board: board),
    );
  }
}