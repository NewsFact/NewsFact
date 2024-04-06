import 'package:http/http.dart' as http;
import 'package:newsfact/utils/datetime.dart';
import 'package:universal_feed/universal_feed.dart';

Future<UniversalFeed?> getFeed(Uri uri) async{
  try {
    var rssContent = await http.get(uri);
    var feed = UniversalFeed.parseFromString(rssContent.body);
    return feed;
  } catch(e) {
    Exception(e);
  }
}

Future<List<Item>> getFeeds(List<Uri> uris) async {
  List<Item> allFeeds = [];
  
  // Fetch and parse feeds from each URI
  for (Uri uri in uris) {
    UniversalFeed? feed = await getFeed(uri);

    if (feed?.items != null) {
      allFeeds.addAll(feed!.items); // Add parsed items to allFeeds list
    }
  }
  
  // Sort the allFeeds list by date published
  allFeeds.sort((a, b) {
    print("${a.title} ${a.updated.toString()}");
    var aDateTime = parseDateTime(a.published.toString());
    var bDateTime = parseDateTime(b.published.toString());
    return bDateTime.compareTo(aDateTime);
  });
  
  return allFeeds;
}

