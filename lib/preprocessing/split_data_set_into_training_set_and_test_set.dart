import 'dart:math';

class SplitDatasetIntoTrainingsetAndTestset {
  late final List<List<double>> trainingVectors;
  late final List<List<double>> testVectors;
  late final List<List<double>> trainingLabels;
  late final List<List<double>> testLabels;
  SplitDatasetIntoTrainingsetAndTestset(
      {required List<List> vectors,
      required List<List> labels,
      double testFraction = 0.2,
      int? seed}) {
    final List<List<double>> trainingVectors = List.from(vectors);
    final List<List<double>> testVectors = List.empty(growable: true);
    final List<List<double>> trainingLabels = List.from(labels);
    final List<List<double>> testLabels = List.empty(growable: true);
    for (int i = 0; i < trainingVectors.length * testFraction; i++) {
      final index = Random(seed).nextInt(trainingVectors.length);
      testVectors.add(trainingVectors[index]);
      trainingVectors.remove(trainingVectors[index]);
      testLabels.add(trainingLabels[index]);
      trainingLabels.remove(trainingLabels[index]);
    }
    this.trainingVectors = trainingVectors;
    this.testVectors = testVectors;
    this.trainingLabels = trainingLabels;
    this.testLabels = testLabels;
    // Labels
  }
}
