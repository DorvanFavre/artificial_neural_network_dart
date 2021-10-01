import 'package:artificial_neural_network/artificial_neural_network/output_function/softmax.dart';

import 'no_output_function.dart';

abstract class OutputFunction {
  factory OutputFunction.none() {
    return NoOutputFunction();
  }
  factory OutputFunction.softmax() {
    return SoftMax();
  }

  const OutputFunction();
  String summary();

  List<double> call(List<double> inputs);
  List<double> derivative(
      {required List<double> expected, required List<double> predicted});
}
