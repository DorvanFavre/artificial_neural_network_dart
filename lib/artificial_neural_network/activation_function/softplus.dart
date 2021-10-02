import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';

class Softplus implements ActivationFunction {
  const Softplus();

  @override
  String summary() {
    return 'Softplus';
  }

  @override
  double call(double input) {
    return log(1.0 + exp(input));
  }

  @override
  double derivative(double input) {
    return 1.0 / (1.0 + exp(-input));
  }

  @override
  // TODO: implement name
  String get name => 'softplus';
}
