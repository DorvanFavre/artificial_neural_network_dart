import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/ann/ann.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/layer/layer.dart';
import 'package:artificial_neural_network/artificial_neural_network/loss_function/loss_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/matrix/matrix.dart';
import 'package:artificial_neural_network/artificial_neural_network/neurone.dart';
import 'package:artificial_neural_network/artificial_neural_network/output_function/output_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/results/learning_result.dart';
import 'package:artificial_neural_network/artificial_neural_network/results/prediction_result.dart';

/// ANN4 16.09.2021
///
/// Propagate error insteed of calculate full path derivative
///
/// Working well with classification with dummy variables (0.0 / 1.0)
///
/// - multi inputs OK
/// - multi ouptus OK
/// - Use relu for output AND hidden layer 1/10 sigmoid
/// - one hidden lyer with two or more neurones is the best
///
/// Carefull, if learning rate to high (0.1), bias and weights explodes (100 - 1000 insteed of 0-1)
/// - learning rate to 0.001
///
/// if there is not enough neurones in the hidden layer, weight and bias explode also
///
/// Output activation function :
///   - None: work well if SMALL learning rate (0.001) otherwise overflow weights
///   - Softplus : take more time but avoid overflow so increase learning rate (0.01)
///   - Sigmoid : totaly avoid overflow, learning rate (0.1) <--- BEEEEEST
///
class ANN4 implements ANN {
  final List<Layer> layers;
  final int numberOfInputs;
  final Initializer initializer;
  final LossFunction lossFunction;
  final OutputFunction outputFunction;
  final double learningRate;

  ANN4(
      {required this.layers,
      required this.numberOfInputs,
      required this.initializer,
      required this.lossFunction,
      required this.outputFunction,
      required this.learningRate}) {}

  bool isBuilt = false;

  void build() {
    Layer? previousLayer = null;
    layers.forEach((layer) {
      layer.build(
          numberOfInputs: previousLayer?.numberOfNeurones ?? numberOfInputs,
          initializer: initializer);
      previousLayer = layer;
    });
    isBuilt = true;
  }

  @override
  String toString() {
    if (isBuilt) {
      String summary =
          '\n=============================\nArtificial Neural Network\n\nNumber of inputs: $numberOfInputs\nNumber of layers: ${layers.length}\n';
      for (int i = 0; i < layers.length; i++) {
        summary += '\n----------------- Layer $i';
        summary += layers[i].toString();
      }
      summary += '\n\nInitializer : ${initializer.summary()}';
      summary += '\nLoss Function: ${lossFunction.toString()}';
      summary += '\nOutput Function: ${outputFunction.toString()}';
      return summary;
    } else {
      return 'Artificial Neural Network not yet built !';
    }
  }

  @override
  LearningResult learn(
      {required List<double> vector, required List<double> label}) {
    String summary = '\n=============================\nLearn\n';
    // Predict
    final prediction = predict(inputs: vector).prediction;
    summary +=
        '\nVector: $vector, Prediction: ${prediction.map((e) => e.toStringAsFixed(3)).toList()}, Reality: $label ';
    // Calcule loss
    final loss = lossFunction(expected: label, predicted: prediction);
    summary += '\nLoss: $loss';

    // Update layers derivative
    layers.forEach((layer) {
      layer.updateLayerDerivative();
    });

    Matrix generalDerivative = Matrix(matrix: [[]]);

    // Add loss function derivative
    final lossFunctionDerivative = Matrix(matrix: [
      for (int n = 0; n < prediction.length; n++)
        [lossFunction.derivative(expected: label, predicted: prediction)]
    ]);
    summary += '\nLoss function derivative:\n$lossFunctionDerivative';

    // Output function derivative
    final outputFunctionDerivative = Matrix.diagonal(
        vector:
            outputFunction.derivative(expected: label, predicted: prediction));
    summary += '\nOutput function derivative:\n$outputFunctionDerivative';

    generalDerivative = outputFunctionDerivative * lossFunctionDerivative;
    summary += '\nGeneral derivative:\n$generalDerivative';

    // For each layer
    for (int layerIndex = layers.length - 1; layerIndex >= 0; layerIndex--) {
      summary += '\n-----------------Layer: $layerIndex';
      final layer = layers[layerIndex];

      // Biases slope
      double calculateBiasSlope(int neuroneIndex) {
        final Matrix biasSlope =
            layer.getBiasDerivative(neuroneIndex: neuroneIndex) *
                generalDerivative;
        return biasSlope.matrix.first.first;
      }

      final biasesSlope = Matrix(matrix: [
        [
          for (int neuroneIndex = 0;
              neuroneIndex < layer.numberOfNeurones;
              neuroneIndex++)
            calculateBiasSlope(neuroneIndex)
        ]
      ]);
      layer.biasesSlope = biasesSlope;
      summary += '\nBiases slope: \n$biasesSlope';

      // Weights slope
      double calculateWeightSlope(int neuroneIndex, int weightIndex) {
        final Matrix weightSlope = layer.getWeightDerivative(
                neuroneIndex: neuroneIndex, weightIndex: weightIndex) *
            generalDerivative;
        return weightSlope.matrix.first.first;
      }

      final weightsSlope = Matrix(matrix: [
        for (int weightIndex = 0;
            weightIndex < layer.numberOfWeights;
            weightIndex++)
          [
            for (int neuroneIndex = 0;
                neuroneIndex < layer.numberOfNeurones;
                neuroneIndex++)
              calculateWeightSlope(neuroneIndex, weightIndex)
          ]
      ]);
      layer.weightsSlope = weightsSlope;
      summary += '\nWeights slope: \n$weightsSlope';

      // Layer derivative
      summary += '\nLayer derivative: \n${layer.layerDerivative}';
      // New General derivative
      generalDerivative = layer.layerDerivative * generalDerivative;
      summary += '\nNew general derivative: \n$generalDerivative';
    }

    // Update weight and bias for each layers
    layers.forEach((layer) {
      layer.bias += layer.biasesSlope * -learningRate;
      layer.weights += layer.weightsSlope * -learningRate;
    });

    return LearningResult(summary: summary, loss: loss);
  }

  @override
  PredictionResult predict({required List<double> inputs}) {
    Matrix data = Matrix(matrix: [inputs]);

    for (int i = 0; i < layers.length; i++) {
      data = layers[i].propagateForward(inputs: data);
    }

    final output = outputFunction(data.matrix.first);

    return PredictionResult(
        prediction: output, rowPrediction: data.matrix.first);
  }

  String train(
      {required List<List<double>> batchVectors,
      required List<List<double>> batchLabels,
      required int maxEpoch,
      double minError = 0.0}) {
    String summary = '';
    double error = 10.0;
    for (int epochIndex = 0;
        epochIndex < maxEpoch && error > minError;
        epochIndex++) {
      final batchVectorsCopy = batchVectors.toList();
      final batchLabelsCopy = batchLabels.toList();

      double lastBatchLosses = 0;

      int i = 0;
      double sum = 0;
      while (batchVectorsCopy.length > 0) {
        final index = Random().nextInt(batchVectorsCopy.length);
        final vector = batchVectorsCopy.removeAt(index);
        final label = batchLabelsCopy.removeAt(index);
        final result = learn(vector: vector, label: label);
        lastBatchLosses = result.loss;
        //summary += 'Batch $i: loss -> $lastBatchLosses';
        sum += lastBatchLosses;

        i++;
      }
      sum = sum / i.toDouble();
      if (sum <= minError) {
        summary += '\nTrain\nMin error reached $sum after $epochIndex Epoch';
        return summary;
      }

      error = sum;
      summary += '\nEpoch $epochIndex: Error -> $error';
    }

    summary += '\nMax epoch reached with error $error';
    return summary;
  }

  @override
  String test(
      {required List<List<double>> vectors,
      required List<List<double>> labels,
      required bool Function(List<double> predicted, List<double> observed)
          evaluator}) {
    int numberOfSuccess = 0;
    for (int i = 0; i < vectors.length; i++) {
      final predicted = predict(inputs: vectors[i]);

      final success = evaluator(predicted.prediction, labels[i]);

      numberOfSuccess += success ? 1 : 0;

      print(
          '\n${vectors[i]}\nrow prediction: ${predicted.rowPrediction}\nprediction: ${predicted.prediction}\nreality: ${labels[i]}\n-> $success');

      // print(
      //   '\n${displayDigit(vector: vectors[i])}\nrow prediction: ${predicted.rowPrediction}\nprediction: ${predicted.prediction}\nreality: ${labels[i]}\n-> $success');
    }
    return 'Test the model --> ${(numberOfSuccess.toDouble() / vectors.length.toDouble()) * 100} %';
  }
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
