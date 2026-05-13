import 'package:flutter/material.dart';
import 'package:frontend/client/sign-up.dart';
import 'package:frontend/other/login.dart';
import 'package:frontend/other/role-page.dart';
import 'package:frontend/other/welcome-page.dart';
import 'package:frontend/worker/profile.dart';
import 'package:frontend/worker/project/step-2.dart';
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
      home: ProjectEditorPage(),
    );
  }
}
