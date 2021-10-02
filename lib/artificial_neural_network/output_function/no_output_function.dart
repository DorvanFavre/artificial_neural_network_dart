import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';

class NoOutputFunction implements OutputFunction {
  @override
  List<double> call(List<double> inputs) {
    return inputs;
  }

  @override
  List<double> derivative(
      {required List<double> expected, required List<double> predicted}) {
    return List.filled(expected.length, 1);
  }

  @override
  String toString() {
    return 'No output function';
  }

  @override
  // TODO: implement name
  String get name => 'none';
}
