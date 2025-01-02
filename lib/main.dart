import 'package:calculator_ranni/firebase_options.dart';
import 'package:calculator_ranni/pages/calculator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculatorApplication(),
  ));
}
