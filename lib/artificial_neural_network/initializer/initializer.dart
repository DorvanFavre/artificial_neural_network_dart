import 'package:artificial_neural_network/artificial_neural_network/initializer/half_initializer.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/random_initializer.dart';

abstract class Initializer {
  factory Initializer.random() {
    return RandomInitializer();
  }
  factory Initializer.half() {
    return HalfInitializer();
  }

  double initializeWeight();
  double initializeBias();
  String summary();
}
