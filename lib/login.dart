import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blogpage.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emaillog = TextEditingController();
  TextEditingController passwordlog = TextEditingController();

  bool rightdata = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emaillog,
                decoration: const InputDecoration(
                  labelText: "Enter Email",
                ),
              ),
              const SizedBox(),
              TextField(
                controller: passwordlog,
                decoration: const InputDecoration(
                  labelText: "Enter Password",
                ),
                obscureText: true,
              ),
              if (!rightdata)
                const Text(
                  "Your data doesn't match up or you are not registered!",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 15.0),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    ElevatedButton(
                        onPressed: () {
                          loginUser(emaillog.text, passwordlog.text);
                        },
                        child: const Text("Login")),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()));
                        },
                        child: const Text("Register"))
                  ]))
            ],
          )),
    );
  }

  Future<void> loginUser(String emaillog, String passwordlog) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? userList = prefs.getStringList("users");
      if (userList != null) {
        for (String userData in userList) {
          User user = User.fromJson(jsonDecode(userData));
          // ignore: unrelated_type_equality_checks
          if (user.email == emaillog && user.password == passwordlog) {
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlogPage(name: user.name)));
            return;
          }
        }
      }
      setState(() {
        rightdata = false;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error while logging in: $error');
    }
  }
}
