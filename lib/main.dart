import 'package:flutter/material.dart';
import 'package:newsfact/home/HomeScreen.dart';
import 'package:newsfact/subscriptions/SubscriptionsScreen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:newsfact/saved/SavedScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {return MaterialApp(
      title: 'NewsFact',
      theme: ThemeData(colorScheme: lightDynamic,),
      darkTheme: ThemeData(colorScheme: darkDynamic,),
      home: const MyHomePage(title: 'NewsFact'),
    );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   int pageIndex = 0;
  final List<Widget> _pages = [//HomeScreen(), 
  FeedsScreen(), SavedScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        destinations: const [
          //NavigationDestination(selectedIcon: Icon(Icons.home), icon: Icon(Icons.home_outlined), label: "Home",), 
          NavigationDestination(selectedIcon: Icon(Icons.subscriptions), icon: Icon(Icons.subscriptions_outlined), label: "Subscriptions",),
          NavigationDestination(selectedIcon: Icon(Icons.bookmark), icon: Icon(Icons.bookmark_outline,), label: "Saved",)
        ],
        onDestinationSelected: (value) => setState(() {
          pageIndex = value;
        }),
      ),
    );
  }
}
