import 'package:aoc2025/aoc2025.dart';
import 'package:aoc2025/day1.dart';
import 'package:aoc2025/day2.dart';
import 'package:aoc2025/day3.dart';
import 'package:aoc2025/day4.dart';
import 'package:aoc2025/day5.dart';
import 'package:aoc2025/day6.dart';
import 'package:aoc2025/day7.dart';
import 'package:aoc2025/day8.dart';
import 'package:aoc2025/day9.dart';

Future<void> main(List<String> arguments) async {
  print('Hello Advent of Code 2025 with Dart!');

  final List<AoCDay> days = [
    Day1(), Day2(), Day3(),
    Day4(), Day5(), Day6(),
    Day7(), Day8(), Day9(), //
  ];
  for (int i = 0; i < days.length; i++) {
    final AoCDay day = days[i];
    day.load();

    print('--- Day ${i + 1} ---');

    final Stopwatch part1Timer = Stopwatch()..start();
    final int part1Result = await day.part1();
    part1Timer.stop();
    print('Part 1 (${part1Timer.printElapsed()}): $part1Result');

    final Stopwatch part2Timer = Stopwatch()..start();
    final int part2Result = await day.part2();
    part2Timer.stop();
    print('Part 2 (${part2Timer.printElapsed()}): $part2Result');

    print('');
  }
}

extension on Stopwatch {
  String printElapsed() {
    if (elapsed.inMicroseconds < 10000) {
      return "${elapsed.inMicroseconds} µs";
    } else if (elapsed.inSeconds < 60) {
      return "${elapsed.inMilliseconds} ms";
    } else {
      return "${elapsed.inSeconds} s";
    }
  }
}
