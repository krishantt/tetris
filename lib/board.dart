import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.T);

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    createNewPiece();

    Duration frameRate = const Duration(milliseconds: 800);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          checkLanding();
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down) || checkLanded()) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  bool checkLanded() {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;
      if (row + 1 < colLength && row >= 0 && gameBoard[row + 1][col] != null) {
        return true; // collision with a landed piece
      }
    }
    return false; // no collision with landed pieces
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotateRight() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                    child: index,
                  );
                } else if (gameBoard[row][col] != null) {
                  final Tetromino? type = gameBoard[row][col];
                  return Pixel(
                    color: type?.color,
                    child: index,
                  );
                } else {
                  return Pixel(
                    color: Colors.grey[900],
                    child: index,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                ),
                IconButton(
                  onPressed: rotateRight,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right),
                ),
                IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
