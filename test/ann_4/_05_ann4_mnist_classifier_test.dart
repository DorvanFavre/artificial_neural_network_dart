import 'dart:io';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:artificial_neural_network/preprocessing/one_hot_encode.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_vectors_and_labels.dart';
import 'package:artificial_neural_network/preprocessing/to_double.dart';
import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../preprocessing_test.dart';

void main() {
  test('Mnist classifier', () async {
    // Import the dataset
    print('Import the dataset...');
    final file = await File('assets/mnist_train.csv').readAsString();
    final file2 = await File('assets/mnist_test.csv').readAsString();
    final trainSet = CsvToListConverter().convert(file, eol: '\n');
    final testSet = CsvToListConverter().convert(file2, eol: '\n');

    trainSet.removeAt(0);

    final trainSet2 = ToDouble(dataset: trainSet);

    print('Split the dataset...');
    final trainSet3 = SplitDatasetIntoVectorsAndLabels(
        dataset: trainSet2.dataset,
        vectorIndexes: [for (int i = 0; i < 28 * 28; i++) i + 1],
        labelIndexes: [0]);

    // Scale data
    print('Scale the vectors...');
    var trainVectors = [
      for (int i = 0; i < trainSet3.vectors.length; i++)
        [for (int j = 0; j < 28 * 28; j++) trainSet3.vectors[i][j] / 255.0]
    ];

    print('One hot encode...');
    var trainLabels = trainSet3.labels;
    OneHotEncode(dataset: trainLabels, indexToEncode: 0, removeLast: false);

    // make the training set smaller
    trainVectors = trainVectors.sublist(0, 10);
    trainLabels = trainLabels.sublist(0, 10);

    /*for (int i = 0; i < trainVectors.length; i++) {
      print(displayDigit(vector: trainVectors[i]));
      print(trainLabels[i]);
    }*/

    print('Create the model...');
    // ANN
    final ann = ANN4(
        layers: [
          Layer.dense(
              numberOfNeurones: 100,
              activationFunction: ActivationFunction.relu()),
          Layer.dense(
              numberOfNeurones: 10,
              activationFunction: ActivationFunction.sigmoid())
        ],
        numberOfInputs: 28 * 28,
        initializer: Initializer.random(),
        lossFunction: LossFunction.crossEntropy(),
        outputFunction: OutputFunction.softmax(),
        learningRate: 0.001);

    ann.build();

    //print(ann);

    // Test
    /*print(ann.test(
        vectors: trainVectors,
        labels: trainLabels,
        evaluator: (predicted, observed) {
          int index = 0;
          for (int i = 0; i < 10; i++) {
            if (predicted[i] == 1.0) index = i;
          }
          return observed[index] == 1.0;
        }));*/

    print('Train the model...');
    // Train
    print(ann.train(
        batchVectors: trainVectors, batchLabels: trainLabels, maxEpoch: 1));

    // Test
    print('Test the model...');
    /*ann.test(
        vectors: trainVectors,
        labels: trainLabels,
        evaluator: (predicted, observed) {
          int index = 0;
          for (int i = 0; i < 10; i++) {
            if (predicted[i] == 1.0) index = i;
          }
          return observed[index] == 1.0;
        });*/

    //print(ann);
  });
}

String displayDigit({required List<double> vector}) {
  String str = '\n';
  for (int y = 0; y < 28; y++) {
    str += '\n';
    for (int x = 0; x < 28; x++) {
      str += vector[x + (y * 28)] == 0.0 ? ' ' : 'm';
    }
  }
  return str;
}
