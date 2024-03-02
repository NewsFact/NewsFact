import 'package:flutter/material.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/feed/_list.dart';
import 'package:newsfact/feed/multi.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  setTabController() async{
    var feeds = await FeedsHelper.feeds();
    tabController = TabController(length: feeds.length, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    setTabController();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(title: Text("Home")),
    body: FutureBuilder<List<Feed>>(future: FeedsHelper.feeds(), builder: (BuildContext c, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
                // While the data is being fetched, you can show a loading indicator.
                return LinearProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs during fetching, you can display an error message.
                return Text('Error: ${snapshot.error}');
              }
                else {
                List<Feed> feeds = snapshot.data;

                  return MultiFeedScreen(feeds.first.url);
                }
  }));
    
    }}