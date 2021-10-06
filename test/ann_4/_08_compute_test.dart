import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class A {
  int fun(int value) {
    var sum = 0;

    for (int j = 0; j < 10; j++) {
      for (var i = 0; i <= value; i++) {
        sum += i;
      }
      print(j);
    }
    print('finished');
    return sum;
  }
}

int computationallyExpensiveTask(A a) {
  return a.fun(100000000);
}

void main() {
  test('Isolate', () async {
    print('start');
    //await compute(computationallyExpensiveTask, A()).then((value) => print(value));
    computationallyExpensiveTask(A());
  });
}
