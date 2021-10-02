import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';

class CrossEntropy implements LossFunction {
  @override
  double call(
      {required List<double> expected, required List<double> predicted}) {
    double sum = 0;
    for (int i = 0; i < expected.length; i++) {
      sum += expected[i] * -log(predicted[i]);
    }
    return sum;
  }

  @override
  String toString() {
    return 'Cross Entropy';
  }

  @override
  double derivative(
      {required List<double> expected, required List<double> predicted}) {
    double sum = 0;
    for (int i = 0; i < expected.length; i++) {
      sum -= expected[i] / predicted[i];
    }
    return sum;
  }

  @override
  // TODO: implement name
  String get name => 'crossEntropy';
}
