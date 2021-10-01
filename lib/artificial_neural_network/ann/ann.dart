import 'package:artificial_neural_network/artificial_neural_network/results/learning_result.dart';
import 'package:artificial_neural_network/artificial_neural_network/results/prediction_result.dart';

abstract class ANN {
  void build();
  PredictionResult predict({required List<double> inputs});
  LearningResult learn(
      {required List<double> vector, required List<double> label});
  String test(
      {required List<List<double>> vectors,
      required List<List<double>> labels,
      required bool Function(List<double> predicted, List<double> observed)
          evaluator});
}
