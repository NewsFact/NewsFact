import 'package:flutter/material.dart';
import 'package:newsfact/addFeed/newsletter.dart';

import 'package:newsfact/addFeed/nitter.dart';
import 'package:newsfact/addFeed/mastodon.dart';
import 'package:newsfact/addFeed/rss.dart';

Future<void> AddDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext c) {return AlertDialog(
      title: Text("Add Feed"),
      content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => TwitterScreen()));
            },
            child: Text("Nitter (X)"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => NewsletterScreen()));
            },
            child: Text("Newsletter"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => RSSScreen()));
            },
            child: Text("RSS/Atom"),
          ),
        ],
      ),
    )
    );});
  }