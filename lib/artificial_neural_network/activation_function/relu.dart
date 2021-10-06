import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';

class Relu implements ActivationFunction {
  const Relu();

  @override
  String summary() {
    return 'Relu';
  }

  @override
  double call(double input) {
    return max(0, input);
  }

  @override
  double derivative(double input) {
    if (input < 0) {
      return 0;
    } else
      return 1;
  }

  @override
  String get name => 'relu';
}
