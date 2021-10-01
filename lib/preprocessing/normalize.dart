class Normalize {
  late final List<List<double>> normalizedDataset;

  Normalize({required List<List<double>> vectors}) {
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

    normalizedDataset = scaledVectors;
  }
}
