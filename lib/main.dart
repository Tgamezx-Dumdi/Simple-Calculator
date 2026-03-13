import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = '0';
  String _expression = '';

  double _firstNumber = 0;
  String _operator = '';
  bool _waitingForSecondNumber = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_display == '0' || _waitingForSecondNumber) {
        _display = number;
        _waitingForSecondNumber = false;
      } else {
        _display += number;
      }

      if (_operator.isNotEmpty) {
        _expression = '$_firstNumber $_operator $_display';
      } else {
        _expression = _display;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      _firstNumber = double.parse(_display);
      _operator = operator;
      _waitingForSecondNumber = true;

      if (_firstNumber == _firstNumber.toInt()) {
        _expression = '${_firstNumber.toInt()} $_operator';
      } else {
        _expression = '$_firstNumber $_operator';
      }
    });
  }

  void _calculateResult() {
    double secondNumber = double.parse(_display);
    double result = 0;

    setState(() {
      if (_operator == '+') {
        result = _firstNumber + secondNumber;
      } else if (_operator == '-') {
        result = _firstNumber - secondNumber;
      } else if (_operator == '*') {
        result = _firstNumber * secondNumber;
      } else if (_operator == '/') {
        if (secondNumber != 0) {
          result = _firstNumber / secondNumber;
        } else {
          _display = 'Error';
          _expression = '';
          _operator = '';
          _waitingForSecondNumber = false;
          return;
        }
      }

      if (result == result.toInt()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }

      _expression = _display;
      _operator = '';
      _waitingForSecondNumber = false;
    });
  }

  void _clearCalculator() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstNumber = 0;
      _operator = '';
      _waitingForSecondNumber = false;
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 80,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Text(
                  _display,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('7', () => _onNumberPressed('7')),
                    _buildButton('8', () => _onNumberPressed('8')),
                    _buildButton('9', () => _onNumberPressed('9')),
                    _buildButton('/', () => _onOperatorPressed('/')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('4', () => _onNumberPressed('4')),
                    _buildButton('5', () => _onNumberPressed('5')),
                    _buildButton('6', () => _onNumberPressed('6')),
                    _buildButton('*', () => _onOperatorPressed('*')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('1', () => _onNumberPressed('1')),
                    _buildButton('2', () => _onNumberPressed('2')),
                    _buildButton('3', () => _onNumberPressed('3')),
                    _buildButton('-', () => _onOperatorPressed('-')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('C', _clearCalculator),
                    _buildButton('0', () => _onNumberPressed('0')),
                    _buildButton('=', _calculateResult),
                    _buildButton('+', () => _onOperatorPressed('+')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
