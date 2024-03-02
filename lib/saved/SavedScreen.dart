import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  State<SavedScreen> createState() => SavedScreenState();
}

class SavedScreenState extends State<SavedScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved"), leading: Icon(Icons.bookmark),),
      body: Center(child: Text("Coming Soon")),
    );
  }
}