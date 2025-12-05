import 'package:aoc2025/aoc2025.dart';
import 'package:aoc2025/day1.dart';
import 'package:aoc2025/day2.dart';
import 'package:aoc2025/day3.dart';
import 'package:aoc2025/day4.dart';
import 'package:aoc2025/day5.dart';
import 'package:test/test.dart';

void main() {
  test('day1', () {
    final AoCDay day = Day1();
    day.load(
      testInput: [
        'L68',
        'L30',
        'R48',
        'L5',
        'R60',
        'L55',
        'L1',
        'L99',
        'R14',
        'L82', //
      ],
    );

    expect(day.part1(), 3);
    expect(day.part2(), 6);
  });

  test('day2', () async {
    final AoCDay day = Day2();
    day.load(
      testInput: [
        '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,'
            '1698522-1698528,446443-446449,38593856-38593862,565653-565659,'
            '824824821-824824827,2121212118-2121212124',
      ],
    );

    expect(await day.part1(), 1227775554);
    expect(await day.part2(), 4174379265);
  });

  test('day3', () async {
    final AoCDay day = Day3();
    day.load(
      testInput: [
        '987654321111111',
        '811111111111119',
        '234234234234278',
        '818181911112111', //
      ],
    );

    expect(day.part1(), 357);
    expect(day.part2(), 3121910778619);
  });

  test('day4', () async {
    final AoCDay day = Day4();
    day.load(
      testInput: [
        '..@@.@@@@.',
        '@@@.@.@.@@',
        '@@@@@.@.@@',
        '@.@@@@..@.',
        '@@.@@@@.@@',
        '.@@@@@@@.@',
        '.@.@.@.@@@',
        '@.@@@.@@@@',
        '.@@@@@@@@.',
        '@.@.@@@.@.', //
      ],
    );

    expect(day.part1(), 13);
    expect(day.part2(), 43);
  });

  test('day5', () async {
    final AoCDay day = Day5();
    day.load(
      testInput: [
        '3-5',
        '10-14',
        '16-20',
        '12-18',
        '',
        '1',
        '5',
        '8',
        '11',
        '17',
        '32', //
      ],
    );

    expect(day.part1(), 3);
    expect(day.part2(), 14);
  });

  test('day6', () async {
    final AoCDay day = Day5();
    day.load(
      testInput: [
        //
      ],
    );

    expect(day.part1(), 0xFF);
    expect(day.part2(), 0xFF);
  });
}
