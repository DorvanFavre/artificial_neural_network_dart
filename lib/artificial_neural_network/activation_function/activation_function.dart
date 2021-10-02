import 'package:artificial_neural_network/artificial_neural_network/activation_function/none.dart';
import 'package:artificial_neural_network/artificial_neural_network/activation_function/relu.dart';
import 'package:artificial_neural_network/artificial_neural_network/activation_function/sigmoid.dart';
import 'package:artificial_neural_network/artificial_neural_network/activation_function/softplus.dart';

abstract class ActivationFunction {
  factory ActivationFunction.relu() {
    return Relu();
  }
  factory ActivationFunction.sigmoid() {
    return Sigmoid();
  }
  factory ActivationFunction.softplus() {
    return Softplus();
  }
  factory ActivationFunction.none() {
    return None();
  }

  factory ActivationFunction.fromName(String name) {
    switch (name) {
      case 'relu':
        return Relu();
      case 'sigmoid':
        return Sigmoid();
      case 'softplus':
        return Softplus();
      case 'none':
        return None();
      default:
        return None();
    }
  }

  const ActivationFunction();
  String summary();

  double call(double input);
  double derivative(double input);
  final String name = '';
}
