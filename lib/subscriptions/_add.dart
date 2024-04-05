import 'package:flutter/material.dart';
import 'package:newsfact/addFeed/newsletter.dart';
import 'package:newsfact/addFeed/mastodon.dart';
import 'package:newsfact/addFeed/rss.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';

Future<void> addDialog(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext c) {
      return ListView(
        shrinkWrap: true,
        children: [
          AppBar(title: Text("Add Feed")),
          buildListTile(context, "Twitter", Image.asset('assets/social_icons/twitter.png', width: 20, color: Theme.of(context).colorScheme.onBackground), SocialImport('twitter')),
          buildListTile(context, "Mastodon", Image.asset('assets/social_icons/mastodon.png', width: 20, color: Theme.of(context).colorScheme.onBackground), SocialImport('mastodon')),
          buildListTile(context, "Newsletter", const Icon(Icons.email) ,NewsletterScreen()),
          buildListTile(context, "RSS", const Icon(Icons.rss_feed), RSSScreen()),
        ],
      );
    },
  );
}

Widget buildListTile(BuildContext context, String title, Widget? image, Widget screen) {
  return ListTile(
    title: Text(title),
    leading: image,
    
    onTap: () {
      Navigator.pop(context); // Close the current modal before opening a new one
      showModalBottomSheet(
        context: context,
        builder: (BuildContext c) => screen,
      );
    },
  );
}

class SocialImport extends StatefulWidget {
  final String type;

  const SocialImport(this.type, {super.key});
  
  @override
  State<SocialImport> createState() => _SocialImportState();
}

class _SocialImportState extends State<SocialImport> {
  TextEditingController _instanceURL = TextEditingController();
  TextEditingController _screenName = TextEditingController();
  double keyboardHeight = 10000.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(_keyboardVisibility);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(_keyboardVisibility as WidgetsBindingObserver);
    _instanceURL.dispose();
    _screenName.dispose();
    super.dispose();
  }

  void _keyboardVisibility(Duration _) {
    if (mounted) {
      final double newKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        keyboardHeight = newKeyboardHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(title: Text("Add Feed")),
          TextField(
            controller: _screenName,
            decoration: InputDecoration(
              hintText: widget.type == 'twitter' ? "@X" : "@Mastodon@mastodon.social",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              suffixIcon: IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.arrow_forward_ios),
          )
            ),
          ),
          if (widget.type == 'twitter')
          ExpansionTile(
            title: Text("Advanced Options"),
            children: [
              TextField(
                controller: _instanceURL,
                decoration: InputDecoration(
                  label: Text("Nitter URL"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    var feeds = await FeedsHelper.feeds();
    FeedsHelper.insertFeed(
      Feed(
        id: feeds.length + 1,
        url: _instanceURL.text.isNotEmpty
            ? "$_instanceURL/${_screenName.text}/rss"
            : "https://nitter.privacydev.net/${_screenName.text}/rss",
        name: "@${_screenName.text}",
        image: "https://twitter.com/favicon.ico",
      ),
    );
  }
}