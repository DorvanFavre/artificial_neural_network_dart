import 'dart:math';

T? cast<T>(x) => x is T ? x : null;

/// Preprocessing v2
/// 01.09.2021
class Preprocessing {
  // Split dataset into trainingset and testset
  /*List<List<List>> splitDatasetIntoTrainingsetAndTestset(
      {required List<List> dataset, double testFraction = 0.2}) {
    final List<List> trainingSet = List.from(dataset);
    final List<List> testSet = List.empty(growable: true);
    for (int i = 0; i < dataset.length * testFraction; i++) {
      final index = Random().nextInt(trainingSet.length);
      testSet.add(trainingSet[index]);
      trainingSet.remove(trainingSet[index]);
    }

    return [trainingSet, testSet];
  }*/

  /// Split dataset into vectors and labels
  List<List> splitDatasetIntoVectorsAndLabels(
      {required List<List> dataset,
      required List<int> vectorIndexes,
      required List<int> labelIndexes}) {
    final List<List> vectors = [
      for (final row in dataset) [for (final index in vectorIndexes) row[index]]
    ];
    final List<List> labels = [
      for (final row in dataset) [for (final index in labelIndexes) row[index]]
    ];

    return [vectors, labels];
  }

  /// Features scaling

  /// Scale each feature between 0.0 an 1.0
  ///
  /// x' = ( x - min(x) ) / ( max(x) - min(x) )
  List<List<double>> normalize({required List<List<double>> vectors}) {
    final numberOfFeatures = vectors.first.length;

    // Get min and max for each features column
    final List<double> featureMinValue = List.empty(growable: true);
    final List<double> featureMaxValue = List.empty(growable: true);
    for (int index = 0; index < numberOfFeatures; index++) {
      featureMinValue.add(vectors.first[index]);
      featureMaxValue.add(vectors.first[index]);
      vectors.forEach((vector) {
        if (vector[index] < featureMinValue[index])
          featureMinValue[index] = vector[index];
        if (vector[index] > featureMaxValue[index])
          featureMaxValue[index] = vector[index];
      });
    }

    // Create new list with scaled vectors
    final List<List<double>> scaledVectors = List.empty(growable: true);

    vectors.forEach((vector) {
      final List<double> scaledVector = List.empty(growable: true);
      for (int index = 0; index < numberOfFeatures; index++) {
        final value = vector[index];
        final scaledValue = (value - featureMinValue[index]) /
            (featureMaxValue[index] - featureMinValue[index]);

        scaledVector.add(scaledValue);
      }
      scaledVectors.add(scaledVector);
    });

    return scaledVectors;
  }
}
