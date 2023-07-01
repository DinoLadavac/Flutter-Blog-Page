import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "blogpage.dart";
import 'dart:convert';
import 'package:intl/intl.dart';

class NewBlogPage extends StatefulWidget {
  final String? author;

  const NewBlogPage({super.key, this.author});

  @override
  _NewBlogPageState createState() => _NewBlogPageState(author: author);
}

class _NewBlogPageState extends State<NewBlogPage> {
  late String? author;
  late String title;
  late String body;
  String currentDate = DateFormat.yMd().add_jms().format(DateTime.now());

  _NewBlogPageState({required this.author});
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Write a new blog!"),
        ),
        body: ListView(padding: const EdgeInsets.all(15.0), children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Title",
            ),
            controller: titlecontroller,
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
          ),
          const SizedBox(),
          TextField(
            decoration: const InputDecoration(
              labelText: "Body",
            ),
            controller: bodycontroller,
            onChanged: (value) {
              setState(() {
                body = value;
              });
            },
          ),
          const SizedBox(),
          ElevatedButton(
              onPressed: () {
                Blog blog = Blog(
                  title: titlecontroller.text,
                  body: bodycontroller.text,
                  author: author,
                  date: currentDate,
                );
                _publishBlog(blog);
              },
              child: const Text("Publish blog!")),
        ]));
  }

  Future<void> _publishBlog(Blog blog) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogs = prefs.getStringList("blogs") ?? [];
    blogs.add(jsonEncode(blog.toJson()));
    await prefs.setStringList("blogs", blogs);
    print("All blogs: $blogs");
    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BlogPage(name: author)));
  }
}
