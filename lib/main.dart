import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white12,
          backgroundColor: const Color.fromARGB(158, 115, 255, 150)),
      home: LoginPage(),
    );
  }
}
