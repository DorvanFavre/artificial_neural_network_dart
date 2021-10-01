/// One Hot Encoder
///
/// Remove last to avoid dummy variable trap (only for vectors and not labels)
class OneHotEncode {
  late final List categories;

  OneHotEncode(
      {required List<List> dataset,
      required int indexToEncode,
      required bool removeLast}) {
    final Set encodeSet = Set();

    dataset.forEach((vector) {
      encodeSet.add(vector[indexToEncode]);
    });

    categories = encodeSet.toList();

    dataset.forEach((vector) {
      final hotEncodedFeatures = encodeSet
          .map((feature) => (feature == vector[indexToEncode]) ? 1.0 : 0.0)
          .toList();

      if (removeLast) hotEncodedFeatures.removeLast();

      vector.removeAt(indexToEncode);
      vector.insertAll(indexToEncode, hotEncodedFeatures);
    });
  }
}
