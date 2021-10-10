import 'dart:io';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:artificial_neural_network/preprocessing/normalize.dart';
import 'package:artificial_neural_network/preprocessing/one_hot_encode.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_training_set_and_test_set.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_vectors_and_labels.dart';
import 'package:artificial_neural_network/preprocessing/to_double.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void fun(void _) async {
  final bool create = true;
  final bool fit = false;
  final bool test = false;

  // Import the dataset
  final file = await File('assets/Social_Network_Ads.csv').readAsString();
  var dataset = CsvToListConverter().convert(file);

  // One hot encode gender
  OneHotEncode(dataset: dataset, indexToEncode: 1, removeLast: true);

  // To double
  dataset = ToDouble(dataset: dataset).dataset;

  // Split into vectors and labels
  final data = SplitDatasetIntoVectorsAndLabels(
      dataset: dataset, vectorIndexes: [1, 2, 3], labelIndexes: [4]);

  final normalizedVectors = Normalize(vectors: data.vectors).normalizedDataset;

  // Split into training and test set
  final sets = SplitDatasetIntoTrainingsetAndTestset(
    vectors: normalizedVectors,
    labels: data.labels,
    testFraction: 0.25,
  );

  //==========================================================================

  // Step 1 - Create model
  if (create) {
    // ANN
    final ann = ANN4(
        name: 'mnist_model_01',
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
        learningRate: 0.01);

    ann.build();
    await ann.saveToFile();
    print('done');
    //print(ann);
  }

  //==========================================================================

  // Setp 2 - Load the model from file, train, save to file

  if (fit) {
    print('Train model');
    final ann = await ANN4.fromFile(file: 'dodo.json');
    ann.train(
        batchVectors: sets.trainingVectors,
        batchLabels: sets.trainingLabels,
        maxEpoch: 1);
    ann.saveToFile();
  }
  //==========================================================================

  // Setp 3 - Load from file and test the model
  if (test) {
    final ann = await ANN4.fromFile(file: 'dodo.json');
    print(ann.test(
        vectors: sets.testVectors,
        labels: sets.testLabels,
        evaluator: (predicted, observed) {
          return (predicted.first - observed.first).abs() < 0.5;
        }));
  }
}

void main() {
  test('hey', () async {
    await compute(fun, null);
  });
}

void fun2(void _) {
  print('coucou');
}
