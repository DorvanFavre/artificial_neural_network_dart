import 'package:artificial_neural_network/artificial_neural_network/matrix/matrix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Multiplication with another matrix', () {
    Matrix b = Matrix(matrix: [
      [1, 2, 3],
      [4, 5, 6]
    ]);

    Matrix a = Matrix(matrix: [
      [4, 5],
      [6, 7],
      [8, 9]
    ]);

    print(a * b);
  });

  test('Addition', () {
    Matrix b = Matrix(matrix: [
      [1, 2, 3],
      [4, 5, 6]
    ]);

    Matrix a = Matrix(matrix: [
      [4, 5, 6],
      [6, 7, 8],
    ]);

    print(a + b);
  });

  test('Order', () {
    Matrix a = Matrix(matrix: [
      [4, 5],
      [6, 7],
      [8, 9]
    ]);
    Matrix b = Matrix(matrix: [
      [1, 2, 3],
      [4, 5, 6]
    ]);

    Matrix c = Matrix(matrix: [
      [4, 4, 9],
      [2, 7, 1],
      [1, 2, 1],
    ]);

    final x = a * b;
    final z = x * c;
    print(z);

    final g = b * c;
    final h = a * g;
    print(h);
  });

  test('Diagonal', () {
    final a = Matrix.diagonal(vector: [2, 4, 5, 6]);
    print(a);
  });

  test('Multiplication with double', () {
    Matrix c = Matrix(matrix: [
      [4, 4, 9],
      [2, 7, 1],
      [1, 2, 1],
    ]);

    print(c * 10.0);
  });
}
