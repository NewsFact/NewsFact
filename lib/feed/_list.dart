import 'package:flutter/material.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/card/card.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:universal_feed/universal_feed.dart';

class FeedView extends StatelessWidget {
  final Uri feedUri;

  const FeedView({super.key, required this.feedUri});
  
  Widget build(BuildContext context) {
  return FutureBuilder<UniversalFeed?>(
        future: getFeed(feedUri),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is being fetched, you can show a loading indicator.
            return LinearProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurs during fetching, you can display an error message.
            return Text('Error: ${snapshot.error}');
          } else {
            // If data is successfully fetched, you can use it to build your UI.
            UniversalFeed? rssFeed = snapshot.data;

            if (rssFeed != null) {
              return ListView.builder(
                itemCount: rssFeed.items.length,
                itemBuilder: (BuildContext c, int index) {
                  var item = rssFeed.items[index];

                  return NewsCard(
                    item.image?.url ?? item.image?.link ?? item.image?.title,
                    (item.title ?? item.description) ?? "",
                    item.authors.first.name,
                    item.published!.value,
                    Uri.parse(item.links.first.href),
                    smallImage: (index % 5) == 0,
                  );
                  }
              );
            } else {
              return Center(child: Text("Unable to fetch feed"));
            }
          }
        },
      );  
  }
}
