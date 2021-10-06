import 'dart:io';
import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/dense_layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:artificial_neural_network/preprocessing/one_hot_encode.dart';
import 'package:artificial_neural_network/preprocessing/preprocessing.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_training_set_and_test_set.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_vectors_and_labels.dart';
import 'package:csv/csv.dart' as csv;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Iris classifier', () async {
    // Import dataset
    final file = await File('assets/iris.csv').readAsString();
    final dataset = csv.CsvToListConverter().convert(file, eol: '\n');

    // One Hot Encode labels
    OneHotEncode(dataset: dataset, indexToEncode: 4, removeLast: false);

    // Split into Vectors and labels
    final vectorsAndLabels = SplitDatasetIntoVectorsAndLabels(
        dataset: dataset, vectorIndexes: [0, 1, 2, 3], labelIndexes: [4, 5, 6]);

    // Split into training set and test set
    final trainingAndTestSets = SplitDatasetIntoTrainingsetAndTestset(
        vectors: vectorsAndLabels.vectors,
        labels: vectorsAndLabels.labels,
        testFraction: 0.25);

    /*print(trainingAndTestSets.trainingVectors.length);
    print(trainingAndTestSets.trainingLabels.length);
    print(trainingAndTestSets.testVectors.length);
    print(trainingAndTestSets.testLabels.length);
    for (int i = 0; i < trainingAndTestSets.trainingLabels.length; i++) {
      print(
          '\n${trainingAndTestSets.trainingVectors[i]} + ${trainingAndTestSets.trainingLabels[i]}');
    }
    print('--------------');
    for (int i = 0; i < trainingAndTestSets.testLabels.length; i++) {
      print(
          '\n${trainingAndTestSets.testVectors[i]} + ${trainingAndTestSets.testLabels[i]}');
    }*/

    // Create the model
    final ann = ANN4(
        layers: [
          DenseLayer(
              numberOfNeurones: 2,
              activationFunction: ActivationFunction.relu()),
          DenseLayer(
              numberOfNeurones: 2,
              activationFunction: ActivationFunction.relu()),
          DenseLayer(
              numberOfNeurones: 2,
              activationFunction: ActivationFunction.relu()),
          DenseLayer(
              numberOfNeurones: 3,
              activationFunction: ActivationFunction.none())
        ],
        numberOfInputs: 4,
        initializer: Initializer.random(),
        lossFunction: LossFunction.crossEntropy(),
        outputFunction: OutputFunction.softmax(),
        learningRate: 0.01);

    // Build the model
    ann.build();

    // Test the model when not trained
    final evaluator = (List<double> predicted, List<double> observed) {
      int predictedIndex = 0;
      int observedIndex = 0;
      double maxPredicted = 0;
      for (int i = 0; i < observed.length; i++) {
        if (observed[i] == 1.0) observedIndex = i;
      }
      for (int i = 0; i < predicted.length; i++) {
        if (predicted[i] > maxPredicted) {
          maxPredicted = predicted[i];
          predictedIndex = i;
        }
      }
      return predictedIndex == observedIndex;
    };

    print('On training Set');
    print(ann.test(
        vectors: trainingAndTestSets.trainingVectors,
        labels: trainingAndTestSets.trainingLabels,
        evaluator: evaluator));

    // Train the model
    final result = ann.train(
        batchVectors: trainingAndTestSets.trainingVectors,
        batchLabels: trainingAndTestSets.trainingLabels,
        maxEpoch: 20);
    print(result);

    print('On test Set');
    print(ann.test(
        vectors: trainingAndTestSets.testVectors,
        labels: trainingAndTestSets.testLabels,
        evaluator: evaluator));

    // Test the model when trained
    /*print(ann.Test(
        testVectors: trainingAndTestSets.testVectors,
        testLabels: trainingAndTestSets.testLabels));*/

    print(ann);
  });
}
