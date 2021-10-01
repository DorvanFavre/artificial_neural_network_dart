import 'package:artificial_neural_network/preprocessing/preprocessing.dart';
import 'package:flutter_test/flutter_test.dart';

final vectors = [
  [0.3, 4.0, 56.0],
  [0.8, 1.0, 89.0],
  [0.6, 9.0, 7.0],
  [0.2, 5.0, 23.0],
];

void main() {
  test('Normalize', () {
    final preprocessing = Preprocessing();

    final result = preprocessing.normalize(vectors: vectors);

    print(result);
  });
}
