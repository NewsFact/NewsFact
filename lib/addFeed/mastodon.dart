import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';

Future<String?> getMastodonFeed(String username) async {
  
}

class MastodonScreen extends StatefulWidget {
  State<MastodonScreen> createState() => MastodonScreenState();
}

class MastodonScreenState extends State<MastodonScreen> {
  TextEditingController usernameController = TextEditingController();
  var feedURL;
  String? username;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import from Mastodon"),),
      body: Padding(padding: EdgeInsets.all(8),child: Column(
        children: [
          TextField(controller: usernameController, decoration: InputDecoration(hintText: "Username (@hcj@fosstodon.org)", prefixText: "@", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () async{
              final _feedURL = await getMastodonFeed(usernameController.text);
              setState(() {
                username = usernameController.text;
                feedURL = _feedURL;
              });
          }, icon: Icon(Icons.arrow_forward)),), maxLength: 500),
          if (feedURL != null)
          if (feedURL != null && feedURL != "Error getting feed")
          FilledButton.tonal(onPressed: () async{
            var feeds = await FeedsHelper.feeds();
            FeedsHelper.insertFeed(Feed(id: feeds.length + 1, url: feedURL, name: username));
          }, child: Text("Import"))
        ],
      ),
    ));
  }
}
