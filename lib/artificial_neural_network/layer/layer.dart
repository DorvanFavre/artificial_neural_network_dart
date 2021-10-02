import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/dense_layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/matrix/matrix.dart';
import '../neurone.dart';

abstract class Layer {
  factory Layer.dense(
      {required int numberOfNeurones,
      required ActivationFunction activationFunction,
      Matrix? weights,
      Matrix? bias}) {
    return DenseLayer(
        numberOfNeurones: numberOfNeurones,
        activationFunction: activationFunction);
  }
  void updateLayerDerivative();
  int get numberOfNeurones;
  int get numberOfWeights;

  /// Be sure to have updated layerDerivative [updateLayerDerivative()] after the last forward propagation (propagateForward())
  Matrix get layerDerivative;
  Matrix propagateForward({required Matrix inputs});
  void build({required int numberOfInputs, required Initializer initializer});
  Matrix getBiasDerivative({required int neuroneIndex});
  Matrix getWeightDerivative(
      {required int neuroneIndex, required int weightIndex});
  Matrix weightsSlope = Matrix.empty();
  Matrix biasesSlope = Matrix.empty();
  Matrix weights = Matrix.empty();
  Matrix bias = Matrix.empty();
  late final ActivationFunction activationFunction;
}
