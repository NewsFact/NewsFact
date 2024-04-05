import 'package:flutter/material.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/group/GroupScreen.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';

class FeedScreen extends StatefulWidget {
  final ScrollController scrollController;

  const FeedScreen({super.key, required this.scrollController});
  
  @override
  State<FeedScreen> createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<List<Feed>>(future: FeedsHelper.feeds(), builder: (BuildContext c, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        List<Feed> feeds = snapshot.data;
        if (feeds.isEmpty == false)
        {
          return GroupScreen(title: 'Feed', feedUri: Uri.parse(feeds[0].url.toString()), scrollController: widget.scrollController);
        } else {
          return Center(child: Text("No feeds found"),);
        }

                  
                
              } else if (snapshot.hasError) {
                // If an error occurs during fetching, you can display an error message.
                return Text('Error: ${snapshot.error}');
              }
              return Container();
  });
    
    }}