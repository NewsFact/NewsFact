import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:newsfact/utils/favicon.dart';
import 'package:universal_feed/universal_feed.dart' as feed;

class RSSScreen extends StatefulWidget {
  State<RSSScreen> createState() => RSSScreenState();
}

class RSSScreenState extends State<RSSScreen> {
  TextEditingController feedController = TextEditingController();
  feed.UniversalFeed? currentFeed;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import from RSS/Atom")),
      body: Padding(padding: EdgeInsets.all(8), child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: feedController, 
              keyboardType: TextInputType.url,
              decoration: InputDecoration(hintText: "https://example.com/feed", suffixIcon: IconButton(icon: Icon(Icons.arrow_forward), onPressed: () async{
                final feed = await getFeed(Uri.parse(feedController.text));
              setState(() {
                currentFeed = feed;
              });
              },), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
            ),

        if(currentFeed != null)
        InkWell(
          onTap: () async{
          var feeds = await FeedsHelper.feeds();
          var name = currentFeed?.title;
          FeedsHelper.insertFeed(Feed(id: feeds.length + 1, url: feedController.text, name: name));
          feedController.clear();
      },
          child: Card(
          child: Padding(padding: EdgeInsets.all(8), child: Flexible(child: Row(
            children: [
              FaviconImage(feedController.text),
              SizedBox(width: 5,),
              Flexible(child: 
              Column(
                children: [
                  if(currentFeed?.title != null) Text(currentFeed!.title!, overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.titleMedium,),
                  if(currentFeed?.description != null) Text(currentFeed!.description!, overflow: TextOverflow.ellipsis, style: Theme.of(context).primaryTextTheme.bodyMedium,),
                ],
              )),
            ],
          )),
        )
      ))])));
      }
  }
