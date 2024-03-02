import 'package:flutter/material.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/feed/_list.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';

class MultiFeedScreen extends StatefulWidget {
  final String feedURL;

  const MultiFeedScreen(this.feedURL, {super.key});
  @override
  State<MultiFeedScreen> createState() => MultiFeedScreenState();
}

class MultiFeedScreenState extends State<MultiFeedScreen> with TickerProviderStateMixin {
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
    
    
    return FutureBuilder<List<Feed>>(future: FeedsHelper.feeds(), builder: (BuildContext c, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
                // While the data is being fetched, you can show a loading indicator.
                return LinearProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs during fetching, you can display an error message.
                return Text('Error: ${snapshot.error}');
              }
                else {
                List<Feed> feeds = snapshot.data;
              
                  List<Tab> tabs = feeds.map((e) => Tab(child: Text(e.name.toString()),)).toList();
                  final pages = feeds.map((e) => FeedView(feedUri: Uri.parse(e.url))).toList();
                  return DefaultTabController(
                    length: tabs.length,

    child: TabBarView(children: pages),
    );
    
    }});
}}