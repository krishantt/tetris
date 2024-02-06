

import 'package:flutter/material.dart';
import 'package:tetris/values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});
  List<int> position = [];

  Color get color {
    return type.color?? Colors.white;
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -6,
          -5,
        ];
        break;
      case Tetromino.I:
        position = [
          -7,
          -4,
          -6,
          -5,
        ];
        break;
      case Tetromino.O:
        position = [
          -16,
          -15,
          -6,
          -5,
        ];
        break;
      case Tetromino.S:
        position = [
          -14,
          -15,
          -6,
          -5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -15,
          -16,
          -6,
          -26,
        ];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }
}
