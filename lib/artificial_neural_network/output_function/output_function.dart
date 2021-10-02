import 'package:artificial_neural_network/artificial_neural_network/activation_function/none.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/softmax.dart';

import 'no_output_function.dart';

abstract class OutputFunction {
  factory OutputFunction.none() {
    return NoOutputFunction();
  }
  factory OutputFunction.softmax() {
    return SoftMax();
  }
  factory OutputFunction.fromName(String name) {
    switch (name) {
      case 'none':
        return NoOutputFunction();
      case 'softmax':
        return SoftMax();
      default:
        return NoOutputFunction();
    }
  }

  const OutputFunction();

  List<double> call(List<double> inputs);
  List<double> derivative(
      {required List<double> expected, required List<double> predicted});

  final String name = '';
}
