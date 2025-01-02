
// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:expressions/expressions.dart' as expressions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calculator_ranni/firestore.dart';
import 'package:calculator_ranni/pages/history.dart';







class CalculatorApplication extends StatefulWidget {
  const CalculatorApplication({super.key});

  @override
  State<CalculatorApplication> createState() => _CalculatorApplicationState();
}

class _CalculatorApplicationState extends State<CalculatorApplication> {
  var result = '0';
  var inputUser = '';
  List<String> history = []; // List to save history

  void buttonPressed(String text) {
    setState(() {
      inputUser = inputUser + text;
    });
  }
  double evaluateExpression(String expressionString) {
  try {
    // Preprocess the input string
    expressionString = expressionString
        .replaceAll('π', 'pi')                           // Replace π with pi
        .replaceAllMapped(
          RegExp(r'(\d+)\^(\(([^)]+)\)|\d+)'), 
          (match) => 'pow(${match[1]}, ${match[2]})')    // Handle power with parentheses
        .replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) => 
            'sqrt(${match[1]})')                         // Replace √(num) with sqrt(num)
        .replaceAllMapped(RegExp(r'(\d+)%'), (match) => 
            '(${match[1]}/100)');                        // Replace num% with (num/100)

    // Parse the expression
    final expression = expressions.Expression.parse(expressionString);

    // Define available functions and constants
    final context = {
      'sin': (num x) => sin(x),            // Sine function
      'cos': (num x) => cos(x),            // Cosine function
      'tan': (num x) => tan(x),            // Tangent function
      'sqrt': (num x) => sqrt(x),          // Square root function
      'pow': (num base, num exp) => pow(base, exp), // Power function
      'abs': (num x) => x.abs(),           // Absolute value function
      'pi': pi                             // Constant pi
    };

    // Evaluate the expression
    final evaluator = const expressions.ExpressionEvaluator();
    final result = evaluator.eval(expression, context);

    // Return the result as double
    if (result is double) {
      return result;
    } else if (result is int) {
      return result.toDouble();
    } else {
      throw FormatException("Invalid result type");
    }
  } catch (e) {
    print("Error evaluating expression: $e");
    throw FormatException("Error evaluating expression");
  }
}
  void addToHistory(String operation, String result) {
    setState(() {
      history.add('$operation = $result');
      Firestore.addResult('$operation = $result');
    });
  }

  Widget getRow(String text1, String text2, String text3, String text4) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Adds spacing between buttons
    children: [
      getButton(text1, Colors.black),
      getButton(text2, Colors.black),
      getButton(text3, Colors.black),
      getButton(text4,const Color.fromARGB(255, 173, 144, 12)),
    ],
  );
}
Widget getRow2(String text1, String text2, String text3, String text4) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Adds spacing between buttons
    children: [
      getButton(text1, Colors.black),
      getButton(text2, Colors.black),
      getButton(text3, Colors.black),
      getButton(text4,const Color.fromARGB(255, 0, 0, 0)),
    ],
  );
}

Widget getButton(String label, Color color) {
  return SizedBox(
    width: 100, // Button width
    height: 50, // Button height
    child: OutlinedButton(
      onPressed: () {
        // Button logic
        if (label == 'AC') {
          setState(() {
            inputUser = '';
            result = '0';
          });
        } else if (label == 'CE') {
          setState(() {
            if (inputUser.isNotEmpty) {
              inputUser = inputUser.substring(0, inputUser.length - 1);
            }
          });
        } else if (label == '=') {
            try {
    // Call the evaluateExpression function with the user's input
              double eval = evaluateExpression(inputUser);
    
    // Update the state with the result
    setState(() {
      result = eval.toString(); // Convert the result to string to display it
    });

            addToHistory(inputUser, result); // Add to history
          } catch (e) {
            setState(() {
              result = 'Error';
            });
          }
        } else {
          buttonPressed(label);
        }
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1), // Button border with transparency
        backgroundColor: color, // Slightly transparent black
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white, // White text color
        ),
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Calculator',
        style: GoogleFonts.poppins(
          color: Colors.white, // White color for the title
          fontSize: 24, // Adjust size as needed
          fontWeight: FontWeight.w600, // Semi-bold
        ),
      ),
      backgroundColor: Colors.black, // Black background for the app bar
      actions: [
        IconButton(
          icon: Icon(Icons.history),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(history: history),
              ),
            );
          },
        ),
      ],
    ),
    body: Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://pbs.twimg.com/media/GR0SK4mWUAAcAQk.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dark overlay
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Main content
        SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        inputUser,
                        style: GoogleFonts.robotoMono(
                          color: Colors.grey[300], // Light grey for input text
                          fontSize: 35, // Adjust size for readability
                          letterSpacing: 1.5, // Add spacing between characters
                        ),
                        textAlign: TextAlign.right, // Align input text to the right
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '=',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 50, // Equal sign font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10), // Space between '=' and result
                          Text(
                            result,
                            style: GoogleFonts.robotoMono(
                              color: Colors.white, // White for result text
                              fontSize: 60, // Larger font size for result
                              fontWeight: FontWeight.w500, // Slightly bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 65,
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 5),
                      getRow2('cos', 'sin', 'tan', '%'),
                      getRow2('√', '^', 'abs', 'π'),
                      getRow('AC', '(', ')', '/'),
                      getRow('1', '2', '3', '*'),
                      getRow('4', '5', '6', '-'),
                      getRow('7', '8', '9', '+'),
                      getRow('CE', '0', '.', '='),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  }
  

