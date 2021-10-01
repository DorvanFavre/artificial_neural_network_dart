class SplitDatasetIntoVectorsAndLabels {
  late final List<List<double>> vectors;
  late final List<List<double>> labels;

  SplitDatasetIntoVectorsAndLabels(
      {required List<List> dataset,
      required List<int> vectorIndexes,
      required List<int> labelIndexes}) {
    vectors = [
      for (final row in dataset) [for (final index in vectorIndexes) row[index]]
    ];
    labels = [
      for (final row in dataset) [for (final index in labelIndexes) row[index]]
    ];
  }
}
