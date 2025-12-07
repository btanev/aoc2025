import 'dart:async';
import 'dart:math' as math;

import 'package:aoc2025/aoc2025.dart';

class Day2 extends AoCDay {
  Day2() : super(inputPath: 'input/day2.txt');

  // https://adventofcode.com/2025/day/2
  //
  // you can find the invalid IDs by looking for any ID which is made only of some sequence of digits repeated twice.
  // So, 55 (5 twice), 6464 (64 twice), and 123123 (123 twice) would all be invalid IDs.
  //
  // None of the numbers have leading zeroes; 0101 isn't an ID at all. (101 is a valid ID that you would ignore.)
  //
  // Your job is to find all of the invalid IDs that appear in the given ranges.
  @override
  Future<int> part1() async {
    final Iterable<IdRange> idRanges = inputLines[0].split(',').map((String rangeStr) => IdRange.fromString(rangeStr));

    final Set<int> invalidIds = {};
    for (final IdRange range in idRanges) {
      await for (final int id in range.identifiers()) {
        if (invalidIds.contains(id)) {
          continue;
        }

        int magnitude = id.magnitude + 1;
        if (magnitude.isOdd) {
          continue;
        }

        magnitude ~/= 2;
        final int divisor = math.pow(10, magnitude).toInt();
        final int firstHalf = id ~/ divisor;
        final int secondHalf = id % divisor;

        if (firstHalf == secondHalf) {
          // print('Invalid ID: $id');
          invalidIds.add(id);
        }
      }
    }

    // print('Invalid IDs: ${invalidIds.length}');
    return invalidIds.reduce((int a, int b) => a + b);
  }

  // https://adventofcode.com/2025/day/2#part2
  //
  // an ID is invalid if it is made only of some sequence of digits repeated _at least_ twice. So, 12341234 (1234 two
  // times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.
  //
  // What do you get if you add up all of the invalid IDs using these new rules?
  @override
  Future<int> part2() async {
    final Iterable<IdRange> idRanges = inputLines[0].split(',').map((String rangeStr) => IdRange.fromString(rangeStr));

    Set<int> invalidIds = {};
    for (final IdRange range in idRanges) {
      await for (final int id in range.identifiers()) {
        if (invalidIds.contains(id)) {
          continue;
        }

        final int magnitude = id.magnitude + 1;
        for (int subLen = 1; subLen <= magnitude ~/ 2; subLen++) {
          if (magnitude % subLen != 0) {
            // can't be constructed by repeating pattern
            continue;
          }

          final int divisor = math.pow(10, subLen).toInt();
          final int repeatCount = magnitude ~/ subLen;
          int pattern = id % divisor;

          int constructedId = 0;
          for (int i = 0; i < repeatCount; i++) {
            constructedId = constructedId * divisor + pattern;
          }

          if (constructedId == id) {
            // print('Invalid ID: $id');
            invalidIds.add(id);
            break;
          }
        }
      }
    }

    // print('Invalid IDs: ${invalidIds.length}');
    return invalidIds.reduce((int a, int b) => a + b);
  }
}

// The ranges are separated by commas (,); each range gives its first ID and last ID separated by a dash (-).
class IdRange {
  final int firstId;
  final int lastId;

  IdRange({required this.firstId, required this.lastId});

  factory IdRange.fromString(String input) {
    final List<String> parts = input.split('-');
    return IdRange(firstId: int.parse(parts[0]), lastId: int.parse(parts[1]));
  }

  Stream<int> identifiers() async* {
    for (int i = firstId; i <= lastId; i++) {
      yield i;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdRange && runtimeType == other.runtimeType && firstId == other.firstId && lastId == other.lastId;

  @override
  int get hashCode => Object.hash(firstId, lastId);

  @override
  String toString() => 'IdRange{start: $firstId, end: $lastId}';
}

extension on int {
  int get magnitude {
    int mag = 0;
    int value = this;
    while (value >= 10) {
      value ~/= 10;
      mag++;
    }
    return mag;
  }
}
