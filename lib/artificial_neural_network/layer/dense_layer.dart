import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/matrix/matrix.dart';
import 'package:artificial_neural_network/artificial_neural_network/neurone.dart';

class DenseLayer implements Layer {
  final int numberOfNeurones;
  late final ActivationFunction activationFunction;

  DenseLayer(
      {required this.numberOfNeurones,
      required this.activationFunction,
      Matrix? weights,
      Matrix? bias}) {
    this.weights = weights ?? Matrix.empty();
    this.bias = bias ?? Matrix.empty();
  }

  Matrix weights = Matrix.empty();
  Matrix bias = Matrix.empty();
  Matrix layerDerivative = Matrix.empty();
  Matrix weightsSlope = Matrix.empty();
  Matrix biasesSlope = Matrix.empty();

  Matrix? inputs;
  Matrix? x;
  Matrix? y;

  @override
  void build({required int numberOfInputs, required Initializer initializer}) {
    weights = Matrix(matrix: [
      for (int w = 0; w < numberOfInputs; w++)
        [
          for (int n = 0; n < numberOfNeurones; n++)
            initializer.initializeWeight()
        ]
    ]);
    bias = Matrix(matrix: [
      [for (int n = 0; n < numberOfNeurones; n++) initializer.initializeBias()]
    ]);
  }

  @override
  Matrix propagateForward(
      {required Matrix inputs, bool updateDerivatives = false}) {
    this.inputs = inputs;
    x = (inputs * weights) + bias;
    y = activateMatrix(matrix: x!, activationFunction: activationFunction);

    /*if (updateDerivatives) {
      derivatives = 
    }*/

    return y!;
  }

  Matrix activateMatrix(
      {required Matrix matrix,
      required ActivationFunction activationFunction}) {
    return Matrix(matrix: [
      for (int i = 0; i < matrix.matrix.length; i++)
        [
          for (int j = 0; j < matrix.matrix.first.length; j++)
            activationFunction(matrix.matrix[i][j])
        ]
    ]);
  }

  Matrix getBiasDerivative({required int neuroneIndex}) {
    double fun(int n) {
      return n == neuroneIndex
          ? activationFunction.derivative(x!.matrix.first[neuroneIndex])
          : 0.0;
    }

    return Matrix(matrix: [
      [for (int n = 0; n < numberOfNeurones; n++) fun(n)]
    ]);
  }

  Matrix getWeightDerivative(
      {required int neuroneIndex, required int weightIndex}) {
    double fun(int n) {
      return n == neuroneIndex
          ? activationFunction.derivative(x!.matrix.first[neuroneIndex]) *
              inputs!.matrix.first[weightIndex]
          : 0.0;
    }

    return Matrix(matrix: [
      [for (int n = 0; n < numberOfNeurones; n++) fun(n)]
    ]);
  }

  void updateLayerDerivative() {
    double fun(int w, int n) {
      return activationFunction.derivative(x!.matrix.first[n]) *
          weights.matrix[w][n];
    }

    layerDerivative = Matrix(matrix: [
      for (int w = 0; w < numberOfWeights; w++)
        [for (int n = 0; n < numberOfNeurones; n++) fun(w, n)]
    ]);
  }

  @override
  String toString() {
    String summary = '\nNumber of neurones : ${numberOfNeurones}\n\n';
    summary += 'Inputs:\n$inputs\n';
    summary += 'Weights:\n${weights.toString()}\n';
    summary += 'Bias:\n${bias.toString()}\n';
    summary += 'X: \n$x\n';
    summary += 'Activation Function : ${activationFunction.summary()}\n';
    summary += 'Y: \n$y\n';
    return summary;
  }

  @override
  int get numberOfWeights => weights.matrix.length;
}
