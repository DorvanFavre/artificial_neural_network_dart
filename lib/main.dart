import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class A {
  int fun(int value) {
    var sum = 0;
    for (var i = 0; i <= value; i++) {
      sum += i;
    }
    print('finished');
    return sum;
  }
}

int computationallyExpensiveTask(A a) {
  return a.fun(1000000000);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          RaisedButton(
            child: Text('start'),
            onPressed: () async {
              //final sum = computationallyExpensiveTask(1000000000);
              final sum = await compute(computationallyExpensiveTask, A());
              print(sum);
            },
          )
        ],
      ),
    );
  }
}
