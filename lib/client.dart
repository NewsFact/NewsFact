import 'package:http/http.dart' as http;
import 'package:universal_feed/universal_feed.dart';

Future<UniversalFeed?> getFeed(uri) async{
  var rssContent = await http.get(uri);
  var feed = UniversalFeed.tryParse(rssContent.body);

  return feed;
}