import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as html;
import 'package:newsfact/dataStore/database_classes.dart';
import 'package:newsfact/dataStore/database_helper.dart';

Future<String> sendPostRequest(String name) async {
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
  } catch (error) {
    return "Error getting email";
  }
}

class NewsletterScreen extends StatefulWidget {
  State<NewsletterScreen> createState() => NewsletterScreenState();
}

class NewsletterScreenState extends State<NewsletterScreen> {
  TextEditingController newsletterName = TextEditingController();
  var email;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Import from newsletter"),),
      body: Padding(padding: EdgeInsets.all(8),child: Column(
        children: [
          TextField(controller: newsletterName, decoration: InputDecoration(hintText: "Name",border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), suffixIcon: IconButton(onPressed: () async{
              final newEmail = await sendPostRequest(newsletterName.text);
              setState(() {
                email = newEmail;
              });
          }, icon: Icon(Icons.arrow_forward)),), maxLength: 500),
          if (email != null)
          Container(
            width: 500,
            height: 60,
            child: Padding(padding: EdgeInsets.all(8),child: Row(children: [SelectableText(email), Spacer(), IconButton(onPressed: () {Clipboard.setData(ClipboardData(text: email));}, icon: Icon(Icons.copy))])),
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.inverseSurface), borderRadius: BorderRadius.circular(16)),
          ),
          if (email != null && email != "Error getting email")
          FilledButton.tonal(onPressed: () async{
            var feeds = await FeedsHelper.feeds();
            FeedsHelper.insertFeed(Feed(id: feeds.length + 1, url: "https://kill-the-newsletter.com/feeds/${email.split('@')[0]}.xml", name: newsletterName.text));
          }, child: Text("Import"))
        ],
      ),
    ));
  }
}
