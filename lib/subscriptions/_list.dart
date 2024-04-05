import 'package:dynamic_color/dynamic_color.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:newsfact/group/GroupScreen.dart';
import 'package:newsfact/utils/favicon.dart';

class FeedsList extends StatefulWidget {
  const FeedsList({super.key});

  State<FeedsList> createState() => FeedsListState();
}

class FeedsListState extends State<FeedsList> {
    @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Feed>>(future: FeedsHelper.feeds(), builder: (BuildContext c, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
                // While the data is being fetched, you can show a loading indicator.
                return ListTile(title: Text("Loading"),);
              } else if (snapshot.hasError) {
                // If an error occurs during fetching, you can display an error message.
                return Text('Error: ${snapshot.error}');
              }
                else {
                List<Feed> feeds = snapshot.data!;

                if (feeds.isNotEmpty) {
                return ListView(
          children: feeds.map((e) => Dismissible(key: widget.key ?? Key(""),
          background: Container(color: Colors.red,child: const Row(children: [Icon(Icons.delete), Spacer(), Icon(Icons.delete)])),
          onDismissed: (direction) async{
                      FeedsHelper.deleteFeed(e.id);
                    },child: ListTile(title: Text(e.name.toString()),
          leading: FaviconImage(e.url),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => GroupScreen(title: e.name!, feedUri: Uri.parse(e.url), scrollController: ScrollController(),))),
          ),)
            ).toList(),
        );
                } else {
                  return const Center(child: Text("No feeds found :("));
                }
  }
                }
    );
  }
}