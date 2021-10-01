class LearningResult {
  final String summary;
  final double loss;

  LearningResult({required this.summary, required this.loss});

  @override
  String toString() {
    return summary;
  }
}
