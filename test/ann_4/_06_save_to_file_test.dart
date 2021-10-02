import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/dense_layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Save to file', () async {
    // Create ANN
    final ann = ANN4(
        name: 'Dodo',
        layers: [
          DenseLayer(
              numberOfNeurones: 6,
              activationFunction: ActivationFunction.relu()),
          DenseLayer(
              numberOfNeurones: 3,
              activationFunction: ActivationFunction.none())
        ],
        numberOfInputs: 3,
        initializer: Initializer.random(),
        lossFunction: LossFunction.crossEntropy(),
        outputFunction: OutputFunction.softmax(),
        learningRate: 0.01);
    ann.build();
    print(ann);

    // save ann
    print('/n=========================');
    print('Try to save file');
    ann.saveToFile().then((value) => print('Saved !'));

    await Future.delayed(Duration(seconds: 1));

    // create ann from file
    final ann2 = await ANN4.fromFile(file: 'Dodo.json');
    print(ann2);
  });
}
