import 'dart:async';

import 'package:aoc2025/aoc2025.dart';

class Day6 extends AoCDay {
  Day6() : super(inputPath: 'input/day6.txt');

  // https://adventofcode.com/2025/day/6
  //
  // list of problems; each problem has a group of numbers that need to be either added (+) or multiplied (*) together.
  //
  // Each problem's numbers are arranged vertically; at the bottom of the problem is the symbol for the operation that
  // needs to be performed. Problems are separated by a full column of only spaces. The left/right alignment of numbers
  // within each problem can be ignored.
  //
  // What is the grand total found by adding together all of the answers to the individual problems?
  @override
  FutureOr<int> part1() {
    final List<List<String>> homework = inputLines.map((line) => line.trim().split(RegExp(r'\s+'))).toList();
    final List<String> operations = homework.last;
    final List<List<int>> numbers = homework
        .sublist(0, homework.length - 1)
        .map((line) => line.map((numStr) => int.parse(numStr)).toList())
        .toList();

    int grandTotal = 0;
    for (int problemIndex = 0; problemIndex < operations.length; problemIndex++) {
      final String operation = operations[problemIndex];

      int problemTotal = numbers[0][problemIndex];
      for (int rowIndex = 1; rowIndex < numbers.length; rowIndex++) {
        final int number = numbers[rowIndex][problemIndex];

        if (operation == '+') {
          problemTotal += number;
        } else if (operation == '*') {
          problemTotal *= number;
        } else {
          throw ArgumentError('Unknown operation: $operation');
        }
      }

      grandTotal += problemTotal;
    }

    return grandTotal; // 7326876294741
  }

  // https://adventofcode.com/2025/day/5#part2
  //
  // Cephalopod math is written right-to-left in columns. Each number is given in its own column, with the most
  // significant digit at the top and the least significant digit at the bottom. (Problems are still separated with a
  // column consisting only of spaces, and the symbol at the bottom of the problem is still the operator to use.)
  //
  // What is the grand total found by adding together all of the answers to the individual problems?
  @override
  FutureOr<int> part2() {
    final List<String> operations = inputLines.last.trim().split(RegExp(r'\s+'));
    final List<String> homework = inputLines.sublist(0, inputLines.length - 1);
    final int maxLineLength = homework.fold(0, (maxLen, line) => line.length > maxLen ? line.length : maxLen);

    // pad each line to the max length, if needed
    homework.replaceRange(0, homework.length, homework.map((line) => line.padRight(maxLineLength, ' ')).toList());
    final int rows = homework.length;
    final int cols = operations.length;

    // parse numbers column by column, detecting columns with only spaces as separators
    // ```
    // 123 328  51 64
    //  45 64  387 23
    //   6 98  215 314
    // *   +   *   +
    // ```
    //   4 + 431 + 623 = 1058
    // 175 * 581 *  32 = 3253600
    //   8 + 248 + 369 = 625
    // 356 *  24 *   1 = 8544
    int cephalopodNumbersColIndex = 0;
    final List<List<int>> cephalopodNumbers = List.generate(cols, (_) => []);
    for (int col = 0; col < maxLineLength; col++) {
      bool colHasNumber = false;
      int cephalopodNumber = 0;

      for (int row = 0; row < rows; row++) {
        final String char = homework[row][col];
        if (char != ' ') {
          colHasNumber = true;
          cephalopodNumber *= 10; // shift left
          cephalopodNumber += int.parse(char); // add digit
        }
      }

      if (colHasNumber) {
        cephalopodNumbers[cephalopodNumbersColIndex].add(cephalopodNumber);
      } else {
        cephalopodNumbersColIndex++; // move to next problem
      }
    }

    // compute the grand total of all problems
    int grandTotal = 0;
    for (int problemIndex = 0; problemIndex < cols; problemIndex++) {
      final String operation = operations[problemIndex];
      final List<int> cephalopodProblemNumbers = cephalopodNumbers[problemIndex];

      int problemTotal = cephalopodProblemNumbers.first;
      for (int rowIndex = 1; rowIndex < cephalopodProblemNumbers.length; rowIndex++) {
        final int number = cephalopodProblemNumbers[rowIndex];

        if (operation == '+') {
          problemTotal += number;
        } else if (operation == '*') {
          problemTotal *= number;
        } else {
          throw ArgumentError('Unknown operation: $operation');
        }
      }
      grandTotal += problemTotal;
    }

    return grandTotal; // 10756006415204
  }
}
