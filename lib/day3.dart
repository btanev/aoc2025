import 'dart:async';

import 'package:aoc2025/aoc2025.dart';

class Day3 extends AoCDay {
  Day3() : super(inputPath: 'input/day3.txt');

  // https://adventofcode.com/2025/day/3
  //
  // The batteries are arranged into banks; each line of digits in your input corresponds to a single bank of batteries.
  // Within each bank, you need to turn on _exactly two_ batteries; the joltage that the bank produces is equal to the
  // number formed by the digits on the batteries you've turned on. For example, if you have a bank like 12345 and you
  // turn on batteries 2 and 4, the bank would produce 24 jolts. (You cannot rearrange batteries.)
  //
  // Find the maximum joltage possible from each bank; what is the total output joltage?
  @override
  FutureOr<int> part1() {
    const batteriesCount = 2;
    final List<String> banks = inputLines;

    final int totalJoltage = _findTotalJoltage(banks, batteriesCount);
    return totalJoltage; // 16993
  }

  // https://adventofcode.com/2025/day/3#part2
  //
  // The joltage output for the bank is still the number formed by the digits of the batteries you've turned on; the
  // only difference is that now there will be _12_ digits in each bank's joltage output instead of two.
  //
  // What is the new total output joltage?
  @override
  FutureOr<int> part2() {
    const batteriesCount = 12;
    final List<String> banks = inputLines;

    final int totalJoltage = _findTotalJoltage(banks, batteriesCount);
    return totalJoltage; // 168617068915447
  }

  int _findTotalJoltage(List<String> banks, int batteriesCount) {
    int totalJoltage = 0;
    for (final String bank in banks) {
      final int bankLength = bank.length;
      int range = bankLength - batteriesCount;

      int startIndex = 0;
      List<int> maxIndices = [];
      do {
        final result = _findMaxValue(bank, startIndex, startIndex + range);
        maxIndices.add(result.index);

        range -= result.index - startIndex;
        startIndex = result.index + 1;
      } while (maxIndices.length < batteriesCount);

      Iterable<int> maxValues = maxIndices.map((int index) => int.parse(bank[index]));
      int maxJoltageValue = maxValues.reduce((int a, int b) => a * 10 + b);

      totalJoltage += maxJoltageValue;
    }
    return totalJoltage;
  }

  ({int index, int value}) _findMaxValue(String bank, int startIndex, int endIndex) {
    int maxValue = int.parse(bank[startIndex]);
    int maxValueIndex = startIndex;
    for (int i = startIndex; i <= endIndex; i++) {
      final int currentValue = int.parse(bank[i]);
      if (currentValue > maxValue) {
        maxValue = currentValue;
        maxValueIndex = i;
      }
    }
    return (index: maxValueIndex, value: maxValue);
  }
}
