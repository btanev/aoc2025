import 'dart:async';

import 'package:aoc2025/aoc2025.dart';

class Day5 extends AoCDay {
  Day5() : super(inputPath: 'input/day5.txt');

  // https://adventofcode.com/2025/day/5
  //
  // The database operates on ingredient IDs.
  // It consists of a list of fresh _ingredient ID ranges_, a _blank line_, and a list of _available ingredient IDs_.
  //
  // The fresh ID ranges are inclusive: the range 3-5 means that ingredient IDs 3, 4, and 5 are all fresh.
  // The ranges can also overlap; an ingredient ID is fresh if it is in any range.
  //
  // How many of the available ingredient IDs are fresh?
  @override
  FutureOr<int> part1() {
    final List<String> database = inputLines;
    final int blankLineIndex = database.indexOf('');
    final List<String> freshIngredientsIdRanges = database.sublist(0, blankLineIndex);
    final List<String> availableIngredientsIds = database.sublist(blankLineIndex + 1);

    final List<Range> mergedFreshRanges = _processFreshIngredientRanges(freshIngredientsIdRanges);

    int freshCount = 0;
    for (final String idStr in availableIngredientsIds) {
      final int ingredientId = int.parse(idStr);
      for (final Range range in mergedFreshRanges) {
        if (range.contains(ingredientId)) {
          freshCount++;
          break;
        }
      }
    }

    return freshCount; // 505
  }

  // https://adventofcode.com/2025/day/5#part2
  //
  // the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh.
  // An ingredient ID is still considered fresh if it is in any range.
  @override
  FutureOr<int> part2() {
    final List<String> database = inputLines;
    final int blankLineIndex = database.indexOf('');
    final List<String> freshIngredientsIdRanges = database.sublist(0, blankLineIndex);

    final List<Range> mergedFreshRanges = _processFreshIngredientRanges(freshIngredientsIdRanges);
    final int totalFreshIngredients = mergedFreshRanges.fold(0, (int sum, Range range) => sum + range.length);
    return totalFreshIngredients; // 344423158480189
  }

  List<Range> _processFreshIngredientRanges(List<String> freshIngredientsIdRanges) {
    final List<Range> freshRanges = freshIngredientsIdRanges.map((String rangeStr) {
      final List<String> parts = rangeStr.split('-');
      final int start = int.parse(parts[0]);
      final int end = int.parse(parts[1]);
      return Range(start, end);
    }).toList();

    freshRanges.sort(); // sort ascending by start value

    final List<Range> mergedFreshRanges = <Range>[];
    mergedFreshRanges.add(freshRanges.first);

    for (int i = 1; i < freshRanges.length; i++) {
      final Range range = freshRanges[i];

      final Range lastRange = mergedFreshRanges.last;
      if (lastRange.hasOverlap(range) || lastRange.end + 1 == range.start) {
        mergedFreshRanges[mergedFreshRanges.length - 1] = lastRange.merge(range);
      } else {
        mergedFreshRanges.add(range);
      }
    }

    return mergedFreshRanges;
  }
}

class Range implements Comparable<Range> {
  final int start;
  final int end;

  const Range(this.start, this.end) : assert(start <= end);

  int get length => end - start + 1;

  bool contains(int value) => start <= value && value <= end;

  bool hasOverlap(Range other) {
    if (start <= other.start && other.start <= end) {
      return true;
    }
    if (start <= other.end && other.end <= end) {
      return true;
    }
    return false;
  }

  Range merge(Range other) {
    final int newStart = start < other.start ? start : other.start;
    final int newEnd = end > other.end ? end : other.end;
    return Range(newStart, newEnd);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'Range{start: $start, end: $end}';

  @override
  int compareTo(Range other) => start.compareTo(other.start);
}
