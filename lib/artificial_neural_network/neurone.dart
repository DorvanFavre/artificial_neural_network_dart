import 'package:artificial_neural_network/artificial_neural_network/activation_function/activation_function.dart';
import 'package:artificial_neural_network/artificial_neural_network/initializer/initializer.dart';
/*
class Neurone {
  final int numberOfInputs;
  final ActivationFunction activationFunction;
  final Initializer initializer;

  Neurone(
      {required this.numberOfInputs,
      required this.activationFunction,
      required this.initializer})
      : weights = List.generate(
          numberOfInputs,
          (index) => initializer.initializeWeight(),
        ),
        weightsGradient = List.filled(numberOfInputs, 0),
        bias = initializer.initializeBias();

  final List<double> weights;
  double bias;

  // input of activation function
  double x = 0;
  // output of activation function
  double y = 0;
  // bias derivative calculated during learning
  double biasGradient = 0;
  List<double> weightsGradient;

  double propagateForward({required List<double> inputs}) {
    x = 0;
    for (int i = 0; i < inputs.length; i++) {
      x += inputs[i] * weights[i];
    }
    x += bias;
    y = activationFunction(x);
    return y;
  }
}
*/