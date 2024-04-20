import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:newsfact/utils/datetime.dart';
import 'package:newsfact/utils/favicon.dart';
import 'package:universal_feed/universal_feed.dart' show Item;
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher_string.dart';

class NewsCard extends StatefulWidget {
  final Item item;

  const NewsCard(this.item, {super.key});

  State<NewsCard> createState() => LargeCardState();
}

class LargeCardState extends State<NewsCard> {
  
  Widget build(BuildContext context) {
    final item = widget.item;

        return Card(child: 
          ListTile(
            onTap: () => launchUrlString(item.link!.href),
            title: Row(children: [
              FaviconImage(item.link!.href.toString(), width: 32,),
              Text(item.authors.toString(),
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(width: 8.0),
                  if(item.published != null && (parseDateTime(item.published!.value) as DateTime?) != null)
                  Text(timeago.format(parseDateTime(item.published!.value)),
                      style: Theme.of(context).textTheme.labelMedium)
            ],),
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(item.image != null)
               ClipRRect(
                child: Image.network(item.image!.url, width: 100,),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              
              if (item.title != null)
              Text(item.title!, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),
              if (item.description != null)
              Html(data: item.description!, onLinkTap: (String? link, _, __) => launchUrl(Uri.parse(link!)), shrinkWrap: true,),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  BookmarkButton()
                ],),
              )
            ],
          ),
        ),
      );
  
  }
}

class BookmarkButton extends StatefulWidget {
  @override
  State<BookmarkButton> createState() => _BookmarkButton();
}

class _BookmarkButton extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline), visualDensity: VisualDensity.compact,);
  }
}