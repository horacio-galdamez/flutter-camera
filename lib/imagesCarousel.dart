import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class ImagesCarousel extends StatelessWidget {
  final photos;
  final callback;

  ImagesCarousel(this.photos, this.callback);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 50),
      child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: List.generate(photos.length, (index) {
            return GestureDetector(
                onTap: () {
                  callback(photos[index], index);
                },
                child: Image.file(
                  photos[index],
                  fit: BoxFit.fill,
                ));
          })),
    );
  }
}
