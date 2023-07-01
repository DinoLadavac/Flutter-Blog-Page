import 'package:flutter/material.dart';
import 'package:ladavacispit/NewBlogPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'MyBlogs.dart';

class Blog {
  String? title;
  String? body;
  String? author;
  String? date;

  Blog(
      {required this.title,
      required this.body,
      required this.author,
      this.date});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        title: json['title'],
        body: json['body'],
        author: json['author'],
        date: json["date"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "author": author,
      "date": date,
    };
  }
}

class BlogPage extends StatefulWidget {
  final String? name;

  const BlogPage({super.key, required this.name});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blog Home"),
        ),
        body: Stack(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome back ${widget.name}!",
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewBlogPage(author: widget.name)));
                    },
                    child: const Text("New Blog"),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyBlogs(author: widget.name),
                        ),
                      );
                    },
                    child: const Text("My Blogs"),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
              top: 100.0,
              child: ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  Blog blog = blogs[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                        title: Center(
                            child: Text(blog.title ?? "",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold))),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                blog.body ?? "",
                                style: const TextStyle(fontSize: 16.0),
                                //maxLines: 2,
                                //overflow: TextOverflow.ellipsis,
                              )),
                              const SizedBox(height: 8.0),
                              Center(
                                  child: Text(
                                "by ${blog.author}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 7, 63, 7),
                                ),
                              )),
                              const SizedBox(),
                              Center(
                                  child: Text(blog.date ?? "",
                                      style: const TextStyle(
                                          color: Colors.black))),
                            ])),
                  );
                },
              )),
        ]));
  }

  Future<void> fetchBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogsData = prefs.getStringList("blogs");

    if (blogsData != null) {
      setState(() {
        blogs = blogsData
            .map((blogData) => Blog.fromJson(jsonDecode(blogData)))
            .toList();
      });
    }
  }
}
