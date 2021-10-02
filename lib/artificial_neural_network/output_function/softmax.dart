import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';

class SoftMax implements OutputFunction {
  @override
  List<double> call(List<double> inputs) {
    double diviseur = 0;
    inputs.forEach((element) {
      diviseur += exp(element);
    });
    return inputs.map((e) => exp(e) / diviseur).toList();
  }

  @override
  List<double> derivative(
      {required List<double> expected, required List<double> predicted}) {
    int trueResultIndex = 0;
    for (int i = 0; i < expected.length; i++) {
      if (expected[i] == 1.0) trueResultIndex = i;
    }
    double fun(int i) {
      return i == trueResultIndex
          ? (predicted[trueResultIndex] * (1.0 - predicted[trueResultIndex]))
          : (-predicted[i] * predicted[trueResultIndex]);
    }

    return [for (int i = 0; i < expected.length; i++) fun(i)];
  }

  @override
  String summary() {
    return 'Softmax';
  }

  @override
  // TODO: implement name
  String get name => 'softmax';
}
