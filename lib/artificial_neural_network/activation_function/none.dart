import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';

class None implements ActivationFunction {
  @override
  double call(double input) {
    return input;
  }

  @override
  String summary() {
    return 'None';
  }

  @override
  double derivative(double input) {
    return 1.0;
  }

  @override
  // TODO: implement name
  String get name => 'none';
}
