import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';

class MeanSquaredError implements LossFunction {
  @override
  double call(
      {required List<double> expected, required List<double> predicted}) {
    double sum = 0;
    for (int i = 0; i < expected.length; i++) {
      sum += pow(expected[i] - predicted[i], 2).toDouble() / 2.0;
    }
    return sum;
  }

  @override
  String toString() {
    return 'Mean Squared Error';
  }

  @override
  double derivative(
      {required List<double> expected, required List<double> predicted}) {
    double sum = 0;
    for (int i = 0; i < expected.length; i++) {
      sum += expected[i] - predicted[i];
    }
    return -sum / expected.length;
  }
}
