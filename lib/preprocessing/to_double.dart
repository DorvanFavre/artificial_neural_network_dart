import 'dart:ffi';

class ToDouble {
  late final List<List<double>> dataset;
  ToDouble({required List<List> dataset}) {
    double calculate(int i, int j) {
      final element = dataset[i][j];
      if (!(element is double)) {
        //element = (element as int).toDouble();
        return (element as int).toDouble();
      } else
        return element;
    }

    this.dataset = [
      for (int i = 0; i < dataset.length; i++)
        [for (int j = 0; j < dataset.first.length; j++) calculate(i, j)]
    ];
  }
}
