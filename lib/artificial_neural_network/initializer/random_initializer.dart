import 'dart:math';

import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';

class RandomInitializer implements Initializer {
  @override
  String summary() {
    return 'Random Initializer';
  }

  @override
  double initializeBias() {
    return Random().nextDouble();
  }

  @override
  double initializeWeight() {
    return Random().nextDouble();
  }
}
