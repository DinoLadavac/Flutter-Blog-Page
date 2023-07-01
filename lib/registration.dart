import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ladavacispit/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? name;
  String? email;
  String? password;
  String? confirmpassword;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmpassword});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        confirmpassword: json['confirmpassword']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "password": password};
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: "Enter Name",
                ),
              ),
              const SizedBox(),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
              ),
              const SizedBox(),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
              TextField(
                controller: confirmpassword,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
                obscureText: true,
              ),
              if (!passwordsMatch)
                const Text(
                  "Passwords don't match! Please enter passwords that are completely the same!",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 15.0),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    ElevatedButton(
                        onPressed: () {
                          User user = User(
                            name: name.text,
                            email: email.text,
                            password: password.text,
                            confirmpassword: confirmpassword.text,
                          );
                          registerUser(user);
                        },
                        child: const Text("Register"))
                  ]))
            ],
          )),
    );
  }

  Future<User> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    String? confirmpassword = prefs.getString("confirmpassword");

    return User(
        name: name,
        email: email,
        password: password,
        confirmpassword: confirmpassword);
  }

  Future<void> registerUser(User user) async {
    try {
      if (user.confirmpassword == user.password) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? instenceofusers = prefs.getStringList("users") ?? [];
        instenceofusers.add(jsonEncode(user.toJson()));

        await prefs.setStringList("users", instenceofusers);
        print("Succefully added registered user $instenceofusers");
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        setState(() {
          passwordsMatch = false;
        });
        return;
      }
      ;
    } catch (error) {
      print("Error while trying to register: $error");
    }
  }
}
