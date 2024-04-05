import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';

class TwitterScreen extends StatefulWidget {
  State<TwitterScreen> createState() => TwitterScreenState();
}

class TwitterScreenState extends State<TwitterScreen> {
  TextEditingController _instanceURL = TextEditingController();
  TextEditingController _screenName = TextEditingController();

  String? instanceURL;
  String? screenName;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import from Twitter"),),
      body: Padding(padding: EdgeInsets.all(8),child: Column(
        children: [
          TextField(controller: _instanceURL, decoration: InputDecoration(label: Text("Instance URL"), prefixText: "https://", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () async{         
              setState(() {
                instanceURL = "https://${_instanceURL.text}";
              });
          }, icon: Icon(Icons.arrow_forward)),), maxLength: 500),
          if (instanceURL != null)
          TextField(controller: _screenName, decoration: InputDecoration(hintText: "Username", prefixText: "@", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () async{      
              setState(() {
                screenName = _screenName.text;
              });
          }, icon: Icon(Icons.arrow_forward)),), maxLength: 500),
          if (screenName != null)
          FilledButton.tonal(onPressed: () async{
            var feeds = await FeedsHelper.feeds();
            FeedsHelper.insertFeed(Feed(id: feeds.length + 1, url: "$instanceURL/${screenName}/rss", name: "@${screenName}", image: "https://twitter.com/favicon.ico"));
          }, child: Text("Import"))
        ],
      ),
    ));
  }
}
