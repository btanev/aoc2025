import 'dart:async';

import 'package:aoc2025/aoc2025.dart';

class Day1 extends AoCDay {
  Day1() : super(inputPath: 'input/day1.txt');

  // https://adventofcode.com/2025/day/1
  //
  // Because the dial is a circle, turning the dial left from 0 one click makes it point at 99. Similarly, turning the
  // dial right from 99 one click makes it point at 0.
  //
  // So, if the dial were pointing at 5, a rotation of L10 would cause it to point at 95. After that, a rotation of R5
  // could cause it to point at 0.
  //
  // The dial starts by pointing at 50.
  //
  // You could follow the instructions, but your recent required official North Pole secret entrance security training
  // seminar taught you that the safe is actually a decoy. The actual password is _the number of times the dial is left
  // pointing at 0 after any rotation in the sequence_.
  //
  // What's the actual password to open the door?
  @override
  FutureOr<int> part1() {
    final List<String> lines = inputLines;
    int currPosition = 50;
    int zeroCount = 0;

    for (final line in lines) {
      final String direction = line[0];
      final int distance = int.parse(line.substring(1));
      final int op = switch (direction) {
        'L' => -1,
        'R' => 1,
        _ => throw Exception('Invalid direction'),
      };

      currPosition = (currPosition + (op * distance)) % 100;
      if (currPosition == 0) {
        zeroCount++;
      }
    }

    return zeroCount; // 1066
  }

  // https://adventofcode.com/2025/day/1#part2
  //
  // You remember from the training seminar that "method 0x434C49434B" means you're actually supposed to count the
  // number of times _any click_ causes the dial to point at 0, regardless of whether it happens during a rotation or at
  // the end of one.
  @override
  FutureOr<int> part2() {
    final List<String> lines = inputLines;
    int currPosition = 50;
    int zeroCount = 0;

    for (final line in lines) {
      final String direction = line[0];
      int distance = int.parse(line.substring(1));
      final int op = switch (direction) {
        'L' => -1,
        'R' => 1,
        _ => throw Exception('Invalid direction'),
      };

      final int startPosition = currPosition;

      if (op == 1) {
        zeroCount += (startPosition + distance) ~/ 100;
      } else {
        // rotating left
        if (distance >= startPosition) {
          // and we pass the 0
          if (startPosition != 0) {
            zeroCount += 1; // account for the 0
          }
          final int distanceAfterZero = distance - startPosition;
          zeroCount += distanceAfterZero ~/ 100; // account for any additional 0s after additional full rotations
        }
      }

      currPosition = (startPosition + (op * distance)) % 100;
    }

    return zeroCount; // 6223
  }
}
