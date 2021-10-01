import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';

class Sigmoid implements ActivationFunction {
  const Sigmoid();

  @override
  String summary() {
    return 'Sigmoid';
  }

  @override
  double call(double input) {
    return 1.0 / (1.0 + exp(-input));
  }

  @override
  double derivative(double input) {
    return call(input) * (1 - call(input));
  }
}
