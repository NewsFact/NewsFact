import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';

class FaviconImage extends StatelessWidget {
  final String url;
  final double? width;

  const FaviconImage(this.url ,{super.key, this.width});
  
  Widget build(BuildContext context) {
    return FutureBuilder(future: FaviconFinder.getBest(url), builder: (BuildContext c, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                // While the data is being fetched, you can show a loading indicator.
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs during fetching, you can display an error message.
                return Text('Error: ${snapshot.error}');
              }
                else {
                  Favicon favicon = snapshot.data;
                  return ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(
                    favicon.url,
                    width: width ?? 32,
                  ));
                }
          },);
  }
}