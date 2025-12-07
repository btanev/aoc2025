import 'dart:async';
import 'dart:collection';

import 'package:aoc2025/aoc2025.dart';

class Day7 extends AoCDay {
  Day7() : super(inputPath: 'input/day7.txt');

  // https://adventofcode.com/2025/day/7
  //
  // A tachyon beam enters the manifold at the location marked S; tachyon beams always move downward. Tachyon beams pass
  // freely through empty space (.). However, if a tachyon beam encounters a splitter (^), the beam is stopped;
  // instead, a new tachyon beam continues from the immediate left and from the immediate right of the splitter.
  //
  // How many times will the beam be split?
  @override
  FutureOr<int> part1() {
    final List<String> tachyonManifold = inputLines;
    final TachyonManifold manifold = TachyonManifold.fromLayout(tachyonManifold);
    manifold.propagateBeams(); // FTL travel, woohoo!

    int splitCount = 0;
    final Set<Beam> visitedBeams = {};
    final Queue<Beam> beamQueue = DoubleLinkedQueue<Beam>(); // BFS queue, layer by layer traversal
    beamQueue.add(manifold.entranceBeam);

    while (beamQueue.isNotEmpty) {
      final Beam currentBeam = beamQueue.removeFirst(); // FIFO
      if (visitedBeams.contains(currentBeam)) {
        continue;
      }
      visitedBeams.add(currentBeam);

      if (currentBeam.nextBeams.length > 1) {
        splitCount++;
      }

      beamQueue.addAll(currentBeam.nextBeams);
    }
    return splitCount;
  }

  // https://adventofcode.com/2025/day/7#part2
  //
  // each time a particle reaches a splitter, it's actually time itself which splits. In one timeline, the particle went
  // left, and in the other timeline, the particle went right.
  //
  // how many different timelines would a single tachyon particle end up on?
  @override
  FutureOr<int> part2() {
    final List<String> tachyonManifold = inputLines;
    final TachyonManifold manifold = TachyonManifold.fromLayout(tachyonManifold);
    manifold.propagateBeams();

    final Map<Beam, int> timelineCache = {};
    int countTimelines(Beam beam) {
      if (timelineCache.containsKey(beam)) {
        return timelineCache[beam]!;
      }

      if (beam.nextBeams.isEmpty) {
        timelineCache[beam] = 1;
        return 1;
      }

      int count = 0;
      for (final Beam nextBeam in beam.nextBeams) {
        count += countTimelines(nextBeam);
      }

      timelineCache[beam] = count;
      return count;
    }

    // DFS with memoization -> make it iterative?
    return countTimelines(manifold.entranceBeam);
  }
}

class TachyonManifold {
  final List<String> layout;
  final Beam entranceBeam;

  TachyonManifold._(this.layout, this.entranceBeam);

  factory TachyonManifold.fromLayout(List<String> layout) {
    late Position entrancePosition;

    for (int row = 0; row < layout.length; row++) {
      final int col = layout[row].indexOf('S');
      if (col >= 0) {
        entrancePosition = (row: row, col: col);
        break;
      }
    }

    final Beam entranceBeam = Beam.fromPosition(entrancePosition);
    return TachyonManifold._(layout.sublist(entrancePosition.row), entranceBeam);
  }

  void propagateBeams() {
    final List<Beam> activeBeams = [entranceBeam];

    while (activeBeams.isNotEmpty) {
      final Beam currentBeam = activeBeams.removeLast();
      if (currentBeam.nextBeams.isNotEmpty) {
        // Already processed
        continue;
      }

      final int nextRow = currentBeam.position.row + 1;
      if (nextRow >= layout.length) {
        // The Beam has exited the manifold
        continue;
      }

      final String nextRowLayout = layout[nextRow];
      currentBeam._buildNextBeams(nextRowLayout);

      for (final Beam nextBeam in currentBeam.nextBeams) {
        if (!activeBeams.contains(nextBeam)) {
          activeBeams.add(nextBeam);
        }
      }
    }
  }
}

typedef Position = ({int row, int col});

class Beam {
  static final Map<Position, Beam> _beamCache = {};

  final Position position;
  final SplayTreeSet<Beam> _nextBeams = SplayTreeSet<Beam>((Beam a, Beam b) {
    if (a.position.row != b.position.row) {
      return a.position.row.compareTo(b.position.row);
    }
    return a.position.col.compareTo(b.position.col);
  });

  Set<Beam> get nextBeams => _nextBeams;

  Beam._(this.position);

  factory Beam.fromPosition(Position position) => _beamCache.putIfAbsent(position, () => Beam._(position));

  Iterable<Beam> _buildNextBeams(String nextRowLayout) {
    if (_nextBeams.isNotEmpty) {
      return _nextBeams;
    }

    final List<Beam> beams = [];
    final int row = position.row + 1; // moves down one row
    final int col = position.col; // same column

    if (nextRowLayout[col] == '^') {
      // split beam columns...
      if (col > 0) {
        beams.add(Beam.fromPosition((row: row, col: col - 1))); // ...left beam
      }
      if (col < nextRowLayout.length - 1) {
        beams.add(Beam.fromPosition((row: row, col: col + 1))); // ...right beam
      }
    } else {
      // beam me down, Scotty
      beams.add(Beam.fromPosition((row: row, col: col)));
    }

    _nextBeams.addAll(beams);
    return _nextBeams;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Beam && runtimeType == other.runtimeType && position == other.position;

  @override
  int get hashCode => position.hashCode;

  @override
  String toString() => 'Beam{position: $position, children: ${_nextBeams.length}';
}
