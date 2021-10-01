import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';

class HalfInitializer implements Initializer {
  @override
  String summary() {
    return 'Half Initializer';
  }

  @override
  double initializeBias() {
    return 0.0;
  }

  @override
  double initializeWeight() {
    return 0.5;
  }
}
