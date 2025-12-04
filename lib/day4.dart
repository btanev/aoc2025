import 'dart:async';

import 'package:aoc2025/aoc2025.dart';

class Day4 extends AoCDay {
  Day4() : super(inputPath: 'input/day4.txt');

  // https://adventofcode.com/2025/day/4
  //
  // The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent
  // positions. If you can figure out which rolls of paper the forklifts can access, they'll spend less time looking and
  // more time breaking down the wall to the cafeteria.
  //
  // How many rolls of paper can be accessed by a forklift?
  @override
  FutureOr<int> part1() {
    final List<List<String>> grid = inputLines
        .map((String line) => line.split('')) //
        .toList(growable: false);

    final List<Location> accessibleLocations = _findAccessibleRolls(grid);
    return accessibleLocations.length; // 1502
  }

  // https://adventofcode.com/2025/day/4#part2
  //
  // Once a roll of paper can be accessed by a forklift, it can be removed. Once a roll of paper is removed, the
  // forklifts might be able to access more rolls of paper, which they might also be able to remove. How many total
  // rolls of paper could the Elves remove if they keep repeating this process?
  @override
  FutureOr<int> part2() {
    final List<List<String>> grid = inputLines
        .map((String line) => line.split('')) //
        .toList(growable: false);

    int totalRemoved = 0;
    while (true) {
      final List<Location> accessibleLocations = _findAccessibleRolls(grid);
      if (accessibleLocations.isEmpty) {
        break;
      }

      totalRemoved += accessibleLocations.length;
      _liftRollsAt(grid, accessibleLocations);
    }

    return totalRemoved; // 9083
  }

  List<Location> _findAccessibleRolls(List<List<String>> grid) {
    final int rows = grid.length;
    final int cols = grid[0].length;

    final List<Location> accessibleLocations = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == '@') {
          int adjacentCount = 0;
          for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
              if (dr == 0 && dc == 0) {
                continue;
              }

              final int nr = r + dr;
              final int nc = c + dc;
              if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
                if (grid[nr][nc] == '@') {
                  adjacentCount++;
                }
              }
            }
          }
          if (adjacentCount < 4) {
            accessibleLocations.add((row: r, col: c));
          }
        }
      }
    }

    return accessibleLocations;
  }

  void _liftRollsAt(List<List<String>> grid, List<Location> locations) {
    for (final Location loc in locations) {
      _liftRollAt(grid, loc);
    }
  }

  void _liftRollAt(List<List<String>> grid, Location loc) => grid[loc.row][loc.col] = '.';
}

typedef Location = ({int row, int col});
