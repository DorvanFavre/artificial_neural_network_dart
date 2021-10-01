import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/dense_layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ANN 4', () {
    final ann = ANN4(
        layers: [
          DenseLayer(
              numberOfNeurones: 2,
              activationFunction: ActivationFunction.relu()),
          DenseLayer(
              numberOfNeurones: 3,
              activationFunction: ActivationFunction.none()),
        ],
        numberOfInputs: 2,
        initializer: Initializer.random(),
        lossFunction: LossFunction.crossEntropy(),
        outputFunction: OutputFunction.softmax(),
        learningRate: 0.1);

    ann.build();

    // predict
    final prediction = ann.predict(inputs: [0.5, 0.5]);

    print(ann);
    print(prediction);

    // Learn
    final result = ann.learn(vector: [0.5, 0.5], label: [1.0, 0.0, 0.0]);
    print(result.summary);

    print(ann);
  });
}
