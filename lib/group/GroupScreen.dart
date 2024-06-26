import 'package:flutter/material.dart';
import 'package:feedify/client.dart';
import 'package:feedify/card/_card.dart';
import 'package:feedify/dataStore/database_classes.dart';
import 'package:universal_feed/universal_feed.dart';

class GroupScreen extends StatelessWidget {
  final List<Uri> feeds;
  final IconData? icon;
  final String title;
  final ScrollController? scrollController;

  const GroupScreen({super.key, required this.title, this.icon, required this.feeds, this.scrollController});
  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: Icon(icon),
     actions: [IconButton(onPressed: () => scrollController?.animateTo(0, duration: Durations.medium1, curve: Curves.fastLinearToSlowEaseIn), icon: Icon(Icons.arrow_upward)), 
     //IconButton(onPressed: () => scrollController, icon: Icon(Icons.refresh))
     ],),
    body: FutureBuilder<List<Item>>(
        future: getFeeds(feeds),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is being fetched, you can show a loading indicator.
            return const LinearProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurs during fetching, you can display an error message.
            return Text('Error: ${snapshot.error}');
          } else {
            // If data is successfully fetched, you can use it to build your UI.
            List<Item>? rssFeed = snapshot.data;

            if (rssFeed != null && rssFeed.isNotEmpty) {
              return ListView.builder(
                controller: scrollController,
                itemCount: rssFeed.length,
                itemBuilder: (BuildContext c, int index) {
                  var item = rssFeed[index];

                  return NewsCard(item);
                  }
              );
            } else {
              return const Center(child: Text("Unable to get posts from your subscriptions"));
            }
          }
        },
      ));  
  }
}