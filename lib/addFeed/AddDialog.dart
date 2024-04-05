import 'package:flutter/material.dart';
import 'package:newsfact/addFeed/newsletter.dart';

import 'package:newsfact/addFeed/nitter.dart';
import 'package:newsfact/addFeed/mastodon.dart';
import 'package:newsfact/addFeed/rss.dart';

Future<void> AddDialog(BuildContext context){
    return showModalBottomSheet(context: context, builder: (BuildContext c) {return ListView(
      shrinkWrap: true,
        children: [
          AppBar(title: Text("Add feed"),),
          ListTile(title: Text("Twitter"), leading: Image.asset("assets/social_icons/twitter.png", width: 20, color: Theme.of(context).colorScheme.onBackground,), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => TwitterScreen()));
            },),
          ListTile(title: Text("Newsletter"), leading: Icon(Icons.email, size: 20, color: Theme.of(context).colorScheme.onBackground,), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => NewsletterScreen()));
            },),
          ListTile(title: Text("RSS"), leading: Icon(Icons.rss_feed, size: 20, color: Theme.of(context).colorScheme.onBackground,), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => RSSScreen()));
            },),
        
        ],
      );
    });
    
  
  }