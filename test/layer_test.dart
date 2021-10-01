import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/dense_layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/matrix/matrix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Layer', () {
    final layer = DenseLayer(
        numberOfNeurones: 3, activationFunction: ActivationFunction.softplus());

    final inputLayer = Matrix(matrix: [
      [2, 3]
    ]);

    layer.build(
        numberOfInputs: inputLayer.matrix.first.length,
        initializer: Initializer.random());

    final prediction = layer.propagateForward(inputs: inputLayer);
    print('prediction: $prediction');

    print(layer);

    final biasDerivative = layer.getBiasDerivative(neuroneIndex: 0);
    print('Bias derivative 0: $biasDerivative');

    final weightDerivative =
        layer.getWeightDerivative(neuroneIndex: 1, weightIndex: 1);
    print('Weight derivative 2-2: $weightDerivative');

    layer.updateLayerDerivative();
    final layerDerivative = layer.layerDerivative;
    print('Layer derivative:\n$layerDerivative');
  });
}
