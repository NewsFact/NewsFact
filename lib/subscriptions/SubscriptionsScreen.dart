import 'package:flutter/material.dart';
import 'package:newsfact/addFeed/AddDialog.dart';
import 'package:newsfact/subscriptions/_list.dart';

class FeedsScreen extends StatefulWidget {
  State<FeedsScreen> createState() => FeedsScreenState();
}

class FeedsScreenState extends State<FeedsScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subscriptions"), leading: Icon(Icons.subscriptions),),
      body: FeedsList(),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add_rounded), onPressed: () => AddDialog(context)),
    );
  }
}