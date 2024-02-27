import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Scientific Calculator",
    theme:
        ThemeData(primarySwatch: Colors.purple, brightness: Brightness.light),
    home: const CalculatorScreen(),
  ));
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';

  final List<String> _buttonValues = [
    'sqrt',
    'sin',
    'cos',
    'tan',
    'sec',
    'csc',
    'log',
    '7',
    '8',
    '9',
    "DEL",
    'AC',
    '4',
    '5',
    '6',
    '*',
    '/',
    '1',
    '2',
    '3',
    '+',
    '-',
    '0',
    '.',
    '=' 
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _display = '';
      }  else if (value == 'DEL') {
      if (_display.isNotEmpty) {
        _display = _display.substring(0, _display.length - 1);
      }
    } else if (value == '=') {
        _display = performCalculation();
      } else if (value == 'sqrt') {
        _display = (math.sqrt(double.parse(_display))).toString();
      } else if (value == 'sin') {
        _display = (math.sin(double.parse(_display))).toString();
      } else if (value == 'cos') {
        _display = (math.cos(double.parse(_display))).toString();
      } else if (value == 'tan') {
        _display = (math.tan(double.parse(_display))).toString();
      } else if (value == 'sec') {
        _display = (1 / math.cos(double.parse(_display))).toString();
      } else if (value == 'csc') {
        _display = (1 / math.sin(double.parse(_display))).toString();
      } else if (value == 'log') {
        _display = (math.log(double.parse(_display))).toString();
      } else {
        _display += value;
      }
    });
  }

  String performCalculation() {
    try {
      // Evaluating the expression
      Parser p = Parser();
      Expression exp = p.parse(_display);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _display,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust the height as needed
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              crossAxisCount: 5,
              shrinkWrap: true,
              children: _buttonValues.map((value) {
                return CalculatorButton(
                  text: value,
                  onPressed: () => _onButtonPressed(value),
                  width: 0,
                  height: 0,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNumberButton =
        RegExp(r'^[0-9]$').hasMatch(text);
        final isNumberButtonequal =
        RegExp(r'^[=,.]$').hasMatch(text);
         // Check if button text is a number
    return MaterialButton(
      onPressed: onPressed,
      color: isNumberButton
          ? Colors.black
          :isNumberButtonequal?Colors.black: Colors.purple, // Change color based on whether it's a number button
      height: height,
      minWidth: width,
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
    );
  }
}
