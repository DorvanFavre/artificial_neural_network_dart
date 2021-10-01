class Matrix {
  final List<List<double>> matrix;

  Matrix({required this.matrix});

  factory Matrix.diagonal({required List<double> vector}) {
    return Matrix(matrix: [
      for (int i = 0; i < vector.length; i++)
        [for (int j = 0; j < vector.length; j++) j == i ? vector[i] : 0.0]
    ]);
  }

  factory Matrix.empty() {
    return Matrix(matrix: [[]]);
  }

  List<List<double>> call() {
    return matrix;
  }

  @override
  String toString() {
    String str = '';
    matrix.forEach((row) {
      str += row.map((e) => e.toStringAsFixed(5)).toList().toString();
      str += '\n';
    });
    return str;
  }

  operator *(Object other) {
    if (other is Matrix) {
      double calculation(int i, int j) {
        double sum = 0;
        for (int k = 0; k < other.matrix.length; k++) {
          sum += other.matrix[k][j] * matrix[i][k];
        }
        return sum;
      }

      return Matrix(matrix: [
        for (int i = 0; i < matrix.length; i++)
          [
            for (int j = 0; j < other.matrix.first.length; j++)
              calculation(i, j)
          ]
      ]);
    }
    if (other is double) {
      return Matrix(matrix: [
        for (int i = 0; i < matrix.length; i++)
          [for (int j = 0; j < matrix.first.length; j++) matrix[i][j] * other]
      ]);
    }
  }

  operator +(Matrix matrix2) {
    return Matrix(matrix: [
      for (int i = 0; i < matrix.length; i++)
        [
          for (int j = 0; j < matrix.first.length; j++)
            matrix[i][j] + matrix2.matrix[i][j]
        ]
    ]);
  }
}
