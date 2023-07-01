import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'blogpage.dart';

class EditDeleteBlog extends StatefulWidget {
  final Blog blog;

  const EditDeleteBlog({super.key, required this.blog});

  @override
  _EditDeleteBlogState createState() => _EditDeleteBlogState();
}

class _EditDeleteBlogState extends State<EditDeleteBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.blog.title ?? "";
    bodyController.text = widget.blog.body ?? "";
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit your Blog"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: "Body"),
                maxLines: null,
              ),
              const SizedBox(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                    onPressed: () {
                      _editBlog();
                      Navigator.pop(context);
                    },
                    child: const Text("Save Changes")),
                ElevatedButton(
                    onPressed: () {
                      _deleteBlog();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlogPage(name: widget.blog.author)),
                      );
                    },
                    child: const Text("Delete post"))
              ])
            ])));
  }

  void _editBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogsData = prefs.getStringList("blogs");
    if (blogsData != null) {
      for (int i = 0; i < blogsData.length; i++) {
        Blog blog = Blog.fromJson(jsonDecode(blogsData[i]));
        if (blog.author == widget.blog.author &&
            blog.title == widget.blog.title) {
          Blog updateBlog = Blog(
            title: titleController.text,
            body: bodyController.text,
            author: widget.blog.author,
            date: blog.date,
          );
          blogsData[i] = jsonEncode(updateBlog.toJson());
          await prefs.setStringList("blogs", blogsData);
          break;
        }
      }
    }
  }

  void _deleteBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogsData = prefs.getStringList("blogs");
    if (blogsData != null) {
      blogsData.removeWhere((blogData) {
        Blog blog = Blog.fromJson(jsonDecode(blogData));
        return blog.author == widget.blog.author &&
            blog.title == widget.blog.title;
      });
      await prefs.setStringList("blogs", blogsData);
    }
  }
}
