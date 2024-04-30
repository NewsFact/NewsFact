import 'package:flutter/material.dart';
import 'package:newsfact/home/_feed.dart';
import 'package:newsfact/saved/SavedScreen.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [FeedScreen(scrollController: scrollController), 
  FeedsScreen(), SavedScreen()];

    return ScaffoldWithBottomNavigation(pages: _pages, scrollController: scrollController,);
  }
}

class ScaffoldWithBottomNavigation extends StatefulWidget {
  final List<Widget> pages;
  final ScrollController scrollController;
  const ScaffoldWithBottomNavigation({super.key, required this.pages, required this.scrollController});

  @override
  State<ScaffoldWithBottomNavigation> createState() => _ScaffoldWithBottomNavigationState();
}

class _ScaffoldWithBottomNavigationState extends State<ScaffoldWithBottomNavigation> {
  int pageIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.rss_feed), label: "Feed",), 
          NavigationDestination(selectedIcon: Icon(Icons.subscriptions), icon: Icon(Icons.subscriptions_outlined), label: "Subscriptions",),
          //NavigationDestination(selectedIcon: Icon(Icons.bookmark), icon: Icon(Icons.bookmark_outline,), label: "Saved",)
        ],
        onDestinationSelected: (value) => setState(() {
          pageIndex = value;
        }),
      ),
    );
  }
}