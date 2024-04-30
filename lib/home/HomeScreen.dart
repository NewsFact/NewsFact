import 'package:flutter/material.dart';
import 'package:newsfact/home/_feed.dart';
import 'package:newsfact/saved/SavedScreen.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [FeedScreen(scrollController: scrollController), 
  FeedsScreen(), //SavedScreen()
  ];

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
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: widget.pages, 
        onPageChanged: (int pageValue) => setState(() => pageIndex = pageValue),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.rss_feed), label: "Feed"), 
          NavigationDestination(selectedIcon: Icon(Icons.subscriptions), icon: Icon(Icons.subscriptions_outlined), label: "Subscriptions"),
          //NavigationDestination(selectedIcon: Icon(Icons.bookmark), icon: Icon(Icons.bookmark_outline), label: "Saved")
        ],
        onDestinationSelected: (value) {
          pageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.ease);
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
