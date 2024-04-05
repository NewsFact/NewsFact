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
      home: HomeScreen(),
    );
    });
  }
}
