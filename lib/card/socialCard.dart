import 'package:flutter/material.dart';
import 'package:newsfact/utils/datetime.dart';
import 'package:newsfact/utils/favicon.dart';
import 'package:universal_feed/universal_feed.dart' as feed;
import 'package:url_launcher/url_launcher.dart';
import 'package:favicon/favicon.dart';

import 'package:flutter/material.dart';
import 'package:newsfact/utils/favicon.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatefulWidget {
  final String? image;
  final bool smallImage;
  final String title;
  final String author;
  final String timestamp;
  final Uri url;

  const NewsCard(this.image, this.title, this.author, this.timestamp, this.url, {super.key, required this.smallImage});

  State<NewsCard> createState() => LargeCardState();
}

class LargeCardState extends State<NewsCard> {
  Widget build(BuildContext context) {
        return InkWell(
        onTap: () {
          launchUrl(widget.url); 
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.image != null)
               ClipRRect(
                child: Image.network(widget.image!, width: widget.smallImage ? 100 : null,),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              Row(
                children: [
                  FaviconImage(widget.url.toString(), width: 32,),
                  SizedBox(width: 5),
                  Text(widget.author,
                      style: Theme.of(context).textTheme.labelMedium),
                  SizedBox(width: 5),
                  if(widget.timestamp != "" && parseDateTime(widget.timestamp) != null)
                  Text(timeago.format(parseDateTime(widget.timestamp)),
                      style: Theme.of(context).textTheme.labelMedium)
                ],
              ),
              Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
              Divider()
            ],
          ),
        ),
      );
  
  }
}
