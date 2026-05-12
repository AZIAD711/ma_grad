import 'package:flutter/material.dart';
import 'package:frontend/client/sign-up.dart';
import 'package:frontend/other/login.dart';
import 'package:frontend/worker/signUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: WorkerSignUpPage(),
    );
  }
}
