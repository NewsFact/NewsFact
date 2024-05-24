import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:dynamic_color/dynamic_color.dart';

import 'package:feedify/home/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {return MaterialApp(
      title: AppLocalizations.of(context)?.feedify ?? "Feedify",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorScheme: lightDynamic,),
      darkTheme: ThemeData(colorScheme: darkDynamic,),
      home: HomeScreen(),
    );
    });
  }
}
