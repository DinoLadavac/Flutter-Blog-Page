import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'blogpage.dart';
import "EditDeleteBlog.dart";

class MyBlogs extends StatefulWidget {
  final String? author;

  const MyBlogs({super.key, required this.author});

  @override
  // ignore: library_private_types_in_public_api
  _MyBlogsState createState() => _MyBlogsState();
}

class _MyBlogsState extends State<MyBlogs> {
  List<Blog> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogsData = prefs.getStringList("blogs");

    if (blogsData != null) {
      for (var blogData in blogsData) {
        Blog blog = Blog.fromJson(jsonDecode(blogData));
        if (blog.author == widget.author) {
          setState(() {
            blogs.add(blog);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My blogs"),
        ),
        body: ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return ListTile(
                  title: Text(blog.title ?? ""),
                  subtitle: Text(
                    "by ${blog.author ?? ""}",
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDeleteBlog(blog: blog)));
                  });
            }));
  }
}
