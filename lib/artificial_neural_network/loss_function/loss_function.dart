import 'package:artificial_neural_network/artificial_neural_network/loss_function/cross_entropy.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/mean_squared_error.dart';

abstract class LossFunction {
  factory LossFunction.meanSquaredError() {
    return MeanSquaredError();
  }
  factory LossFunction.crossEntropy() {
    return CrossEntropy();
  }

  double call(
      {required List<double> expected, required List<double> predicted});

  double derivative(
      {required List<double> expected, required List<double> predicted});
}
