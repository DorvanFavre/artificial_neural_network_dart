/// The purpose of this test is to start/stop the training whenever we want,
/// The progression is saved in a file
/// Stop the programme at anymoment

import 'dart:io';

import 'package:artificial_neural_network/artificial_neural_network/ann/ann_4.dart';
import 'package:artificial_neural_network/preprocessing/one_hot_encode.dart';
import 'package:artificial_neural_network/preprocessing/split_data_set_into_vectors_and_labels.dart';
import 'package:artificial_neural_network/preprocessing/to_double.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void fun(void _) async {
  // Load the dataset
  final watch = Stopwatch()..start();
  print('Load the dataset...');
  final file = await File('assets/mnist_train.csv').readAsString();
  final file2 = await File('assets/mnist_test.csv').readAsString();
  final trainSet = CsvToListConverter().convert(file, eol: '\n');
  final testSet = CsvToListConverter().convert(file2, eol: '\n');

  trainSet.removeAt(0);

  final trainSet2 = ToDouble(dataset: trainSet);

  final trainSet3 = SplitDatasetIntoVectorsAndLabels(
      dataset: trainSet2.dataset,
      vectorIndexes: [for (int i = 0; i < 28 * 28; i++) i + 1],
      labelIndexes: [0]);

  var trainVectors = [
    for (int i = 0; i < trainSet3.vectors.length; i++)
      [for (int j = 0; j < 28 * 28; j++) trainSet3.vectors[i][j] / 255.0]
  ];

  var trainLabels = trainSet3.labels;
  OneHotEncode(dataset: trainLabels, indexToEncode: 0, removeLast: false);

  watch.stop();
  print('in ${watch.elapsed}');

  // Load the model
  print('load the model...');
  final watch2 = Stopwatch()..start();
  final ann = await ANN4.fromFile(file: 'mnist_model_01.json');
  print('in ${watch2.elapsed}');

  // Start fitting the model
  ann.fit(
    vectors: trainVectors,
    labels: trainLabels,
  );
}

void main() {
  test('Start training', () async {
    await compute(fun, null);
  });
}
