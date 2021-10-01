import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/ann/ann.dart';

class Trainer {
  String simpleTrain(
      {required ANN ann,
      required List<List<double>> batchVectors,
      required List<List<double>> batchLabels,
      required int epoch}) {
    String summary = '\nTrain model';
    for (int epochIndex = 0; epochIndex < epoch; epochIndex++) {
      final batchVectorsCopy = batchVectors.toList();
      final batchLabelsCopy = batchLabels.toList();

      double lastBatchLosses = 0.0;

      while (batchVectorsCopy.length > 0) {
        final index = Random().nextInt(batchVectorsCopy.length);
        final vector = batchVectorsCopy.removeAt(index);
        final label = batchLabelsCopy.removeAt(index);
        final result = ann.learn(vector: vector, label: label);
        //lastBatchLosses = result.loss;
        print('\ntrainer: last vector losses: $lastBatchLosses');
      }
      //summary += '\nepoch $epochIndex - losses: $lastBatchLosses';
      //print('epoch $epochIndex - losses: $lastBatchLosses');
    }
    return summary;
  }

  String minimizeEpochTraining(
      {required ANN ann,
      required List<List<double>> batchVectors,
      required List<List<double>> batchLabels,
      required int maxEpoch,
      required double disiredError}) {
    double error = 0;
    for (int epochIndex = 0; epochIndex < maxEpoch; epochIndex++) {
      final batchVectorsCopy = batchVectors.toList();
      final batchLabelsCopy = batchLabels.toList();

      double lastBatchLosses = 0;

      int i = 0;
      double sum = 0;
      while (batchVectorsCopy.length > 0) {
        final index = Random().nextInt(batchVectorsCopy.length);
        final vector = batchVectorsCopy.removeAt(index);
        final label = batchLabelsCopy.removeAt(index);
        final result = ann.learn(vector: vector, label: label);
        //lastBatchLosses = result.loss;

        sum += lastBatchLosses;
        i++;
      }
      sum = sum / i.toDouble();
      if (sum <= disiredError)
        return 'error reach $sum after $epochIndex Epoch';
      error = sum;
    }

    return 'Cannot reach error treshold. Error: $error';
  }
}
