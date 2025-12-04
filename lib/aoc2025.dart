import 'dart:async';
import 'dart:io';

abstract class AoCDay {
  final File _inputFile;
  List<String>? _inputLines;

  List<String> get inputLines => _inputLines ??= _inputFile.readAsLinesSync();

  AoCDay({required String inputPath}) : _inputFile = File(inputPath);

  void load({List<String>? testInput}) {
    if (testInput != null) {
      _inputLines = testInput;
      return;
    }

    _inputLines = _inputFile.readAsLinesSync();
  }

  FutureOr<int> part1();

  FutureOr<int> part2();
}
