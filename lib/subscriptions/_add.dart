import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsfact/client.dart';
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:universal_feed/universal_feed.dart' as universal_feed;

Future<void> addDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
        title: Text("Add Feed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
          buildListTile(context, "Twitter", Image.asset('assets/social_icons/twitter.png', width: 20, color: Theme.of(context).colorScheme.onBackground), SocialImport('twitter')),
          buildListTile(context, "Mastodon", Image.asset('assets/social_icons/mastodon.png', width: 20, color: Theme.of(context).colorScheme.onBackground), SocialImport('mastodon')),
          buildListTile(context, "Newsletter", const Icon(Icons.email) ,NewsletterScreen()),
          buildListTile(context, "RSS", const Icon(Icons.rss_feed), RSSScreen()),
        ]),
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
      showDialog(
        context: context,
        builder: (BuildContext c) => screen,
      );
    },
  );
}

void addFeed(feedURL, name, image) async {
    var feeds = await FeedsHelper.feeds();
    print(feeds.length);
    FeedsHelper.insertFeed(
      Feed(
        id: feeds.length + 1,
        url: feedURL,
        name: name,
        image: image,
      ),
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

  @override
  void dispose() {
    _instanceURL.dispose();
    _screenName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: AppBar(title: Text("Add Feed")), content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          TextField(
            controller: _screenName,
            decoration: InputDecoration(
              hintText: "Enter your username",
              prefixText: '@',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              suffixIcon: IconButton(
            onPressed: () => addFeed(_instanceURL.text.isNotEmpty ? "$_instanceURL/${_screenName.text}/rss": "https://nitter.privacydev.net/${_screenName.text}/rss", _screenName.text, "https://twitter.com/favicon.ico"),
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
    ));
  }
}

class RSSScreen extends StatefulWidget {
  State<RSSScreen> createState() => RSSScreenState();
}

class RSSScreenState extends State<RSSScreen> {
  TextEditingController feedController = TextEditingController();
  universal_feed.UniversalFeed? currentFeed;
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Import from RSS"),
      content: Padding(padding: EdgeInsets.all(8), child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: feedController, 
              keyboardType: TextInputType.url,
              decoration: InputDecoration(labelText: "URL", prefixText: "https://", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))), onEditingComplete: () async{
                final feed = await getFeed(Uri.parse("https://${feedController.text}"));
              setState(() {
                currentFeed = feed;
              });
              },)])),
            
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () {if (currentFeed != null) addFeed((currentFeed?.xmlLink?.href ?? feedController.text), currentFeed?.title, currentFeed?.image?.url);}, child: Text("Add feed", style: TextStyle(color: currentFeed == null ? Theme.of(context).disabledColor : Theme.of(context).buttonTheme.colorScheme?.primary),)),
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
      );
      }
  }

Future<String?> sendPostRequest(String name) async {
  var url = Uri.parse('https://kill-the-newsletter.com/');
  var headers = {
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
        "Cache-Control": "max-age=0",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded",
        "DNT": "1",
        "Host": "kill-the-newsletter.com",
        "Origin": "https://kill-the-newsletter.com",
        "Referer": "https://kill-the-newsletter.com/",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "same-origin",
        "Sec-Fetch-User": "?1",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
        "sec-ch-ua": "\"Not A(Brand\";v=\"99\", \"Google Chrome\";v=\"121\", \"Chromium\";v=\"121\"",
        "sec-ch-ua-mobile": "?1",
        "sec-ch-ua-platform": "\"macOS\"",
  };
  var body = {"name": name};

  try {
    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Parse the HTML response
    var document = htmlParser.parse(response.body);

    // Extract email and feed URL
    var emailElement = document.querySelector('.copyable');

    var email = emailElement?.text ?? 'Email not found';

    // Print or use the extracted values
    return email;
  } catch (e) {
    Exception(e);
  }
}

class NewsletterScreen extends StatefulWidget {
  State<NewsletterScreen> createState() => NewsletterScreenState();
}

class NewsletterScreenState extends State<NewsletterScreen> {
  TextEditingController newsletterName = TextEditingController();
  var email;
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Import from newsletter"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: newsletterName, decoration: InputDecoration(hintText: "Name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () async{
              final newEmail = await sendPostRequest(newsletterName.text);
              setState(() {
                email = newEmail;
              });
          }, icon: Icon(Icons.arrow_forward)),), maxLength: 500),
          if (email != null)
          TextField(controller: TextEditingController(text: email), readOnly: true, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () {Clipboard.setData(ClipboardData(text: email));}, icon: Icon(Icons.copy))), maxLength: 500),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () {if (email != null) addFeed("https://kill-the-newsletter.com/feeds/${email.split('@')[0]}.xml", newsletterName.text, null);}, child: Text("Add feed", style: TextStyle(color: email == null ? Theme.of(context).disabledColor : Theme.of(context).buttonTheme.colorScheme?.primary),)),
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
  }
}
