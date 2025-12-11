import 'dart:async';
import 'dart:math';

import 'package:aoc2025/aoc2025.dart';
import 'package:collection/collection.dart';

class Day8 extends AoCDay {
  Day8() : super(inputPath: 'input/day8.txt');

  // https://adventofcode.com/2025/day/8
  //
  // connect the junction boxes with long strings of lights. Most of the junction boxes don't provide electricity;
  // however, when two junction boxes are connected by a string of lights, electricity can pass between those two
  // junction boxes.
  //
  // The Elves are trying to figure out which junction boxes to connect so that electricity can reach every
  // junction box.
  //
  // connect together the 1000 pairs of junction boxes which are closest together. Afterward, what do you get if you
  // multiply together the sizes of the three largest circuits?
  @override
  FutureOr<int> part1() {
    final List<String> junctionBoxLines = inputLines;
    final List<JunctionBox> junctionBoxes = junctionBoxLines.map((line) => JunctionBox.fromString(line)).toList();

    // add all pairs to the pq to be sorted by distance
    final PriorityQueue<JunctionBoxPair> pq = PriorityQueue();
    for (int i = 0; i < junctionBoxes.length; i++) {
      for (int j = i + 1; j < junctionBoxes.length; j++) {
        pq.add(JunctionBoxPair(junctionBoxes[i], junctionBoxes[j]));
      }
    }

    // 1. Create graph with all junction boxes as nodes
    // 2. Process pairs in order of distance, connecting junction boxes => adding edges
    // 3. Traverse graph to find connected components (circuits)
    // 4. Get sizes of circuits

    final Map<JunctionBox, Set<JunctionBox>> graph = {};
    for (final box in junctionBoxes) {
      graph[box] = {box}; // each box is its own circuit initially
    }

    int processedConnections = 0;
    // const int targetConnections = 10; // example case
    const int targetConnections = 1000;
    while (processedConnections < targetConnections && pq.isNotEmpty) {
      final JunctionBoxPair closestPair = pq.removeFirst();
      final JunctionBox boxA = closestPair.boxA;
      final JunctionBox boxB = closestPair.boxB;

      final Set<JunctionBox> circuitA = graph[boxA]!;
      final Set<JunctionBox> circuitB = graph[boxB]!;

      processedConnections++;

      // skip, if already connected
      if (DeepCollectionEquality().equals(circuitA, circuitB)) {
        continue;
      }

      // connect, 2 ways
      final Set<JunctionBox> mergedCircuit = {...circuitA, ...circuitB};
      for (final box in mergedCircuit) {
        graph[box] = mergedCircuit;
      }
    }

    // get all unique circuits and their lengths
    final Set<Set<JunctionBox>> uniqueCircuits = {};
    for (final circuit in graph.values) {
      uniqueCircuits.add(circuit);
    }
    final List<int> circuitSizes = uniqueCircuits.map((circuit) => circuit.length).toList();
    circuitSizes.sort((a, b) => b.compareTo(a)); // descending

    // multiply sizes of 3 largest circuits - our goal
    final int result = circuitSizes.take(3).reduce((a, b) => a * b);
    return result;
  }

  // https://adventofcode.com/2025/day/8#part2
  //
  // The Elves were right; they definitely don't have enough extension cables. You'll need to keep connecting junction
  // boxes together until they're all in one large circuit.
  //
  // Continue connecting the closest unconnected pairs of junction boxes together until they're all in the same circuit.
  // What do you get if you multiply together the X coordinates of the last two junction boxes you need to connect?
  @override
  FutureOr<int> part2() {
    final List<String> junctionBoxLines = inputLines;
    final List<JunctionBox> junctionBoxes = junctionBoxLines.map((line) => JunctionBox.fromString(line)).toList();
    final int junctionBoxesCount = junctionBoxes.length;

    final PriorityQueue<JunctionBoxPair> pq = PriorityQueue();
    for (int i = 0; i < junctionBoxesCount; i++) {
      for (int j = i + 1; j < junctionBoxesCount; j++) {
        pq.add(JunctionBoxPair(junctionBoxes[i], junctionBoxes[j]));
      }
    }

    final Map<JunctionBox, Set<JunctionBox>> graph = {};
    for (final box in junctionBoxes) {
      graph[box] = {box};
    }

    JunctionBoxPair? lastConnectedPair;
    while (pq.isNotEmpty) {
      final JunctionBoxPair closestPair = pq.removeFirst();
      final JunctionBox boxA = closestPair.boxA;
      final JunctionBox boxB = closestPair.boxB;

      final Set<JunctionBox> circuitA = graph[boxA]!;
      final Set<JunctionBox> circuitB = graph[boxB]!;

      if (DeepCollectionEquality().equals(circuitA, circuitB)) {
        // skip, if already connected...
        if (circuitA.length == junctionBoxesCount) {
          // ... unless all junction boxes are now connected, then we are done
          break;
        }

        continue;
      }

      final Set<JunctionBox> mergedCircuit = {...circuitA, ...circuitB};
      for (final box in mergedCircuit) {
        graph[box] = mergedCircuit;
      }

      lastConnectedPair = closestPair;
    }

    return lastConnectedPair!.boxA.x * lastConnectedPair!.boxB.x;
  }
}

class JunctionBox implements Comparable<JunctionBox> {
  final int x;
  final int y;
  final int z;

  const JunctionBox._(this.x, this.y, this.z);

  factory JunctionBox.fromString(String line) {
    final List<String> parts = line.trim().split(',');
    return JunctionBox._(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  double distanceTo(JunctionBox other) {
    final int dx = x - other.x;
    final int dy = y - other.y;
    final int dz = z - other.z;

    return sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2));
  }

  // Compare junction boxes by their distance to the origin (0,0,0)
  @override
  int compareTo(JunctionBox other) =>
      distanceTo(JunctionBox._(0, 0, 0)).compareTo(other.distanceTo(JunctionBox._(0, 0, 0)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JunctionBox && runtimeType == other.runtimeType && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'JunctionBox{x: $x, y: $y, z: $z}';
}

class JunctionBoxPair implements Comparable<JunctionBoxPair> {
  final JunctionBox boxA;
  final JunctionBox boxB;

  const JunctionBoxPair(this.boxA, this.boxB);

  double get distance => boxA.distanceTo(boxB);

  @override
  int compareTo(JunctionBoxPair other) => distance.compareTo(other.distance);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JunctionBoxPair && runtimeType == other.runtimeType && boxA == other.boxA && boxB == other.boxB;

  @override
  int get hashCode => Object.hash(boxA, boxB);

  @override
  String toString() => 'JunctionBoxPair{boxA: $boxA, boxB: $boxB, distance: $distance}';
}
