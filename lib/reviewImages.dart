import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import './imagesCarousel.dart';

class ReviewImages extends StatefulWidget {
  static final String route = "/review-images";
  final photos;
  final callback;

  ReviewImages(this.photos, {this.callback});

  @override
  _ReviewImagesState createState() => _ReviewImagesState();
}

class _ReviewImagesState extends State<ReviewImages> {
  void _cropImage(photo, index) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: photo.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          title: 'Crop your image',
        ));

    GallerySaver.saveImage(croppedFile.path).then((path) {
      setState(() {
        widget.photos[index] = croppedFile;
      });
      widget.callback(widget.photos);
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
      body: Column(children: [
        Flexible(
            flex: 1,
            child: Container(
                child: SizedBox.expand(
              child: ImagesCarousel(
                  widget.photos, (photo, index) => _cropImage(photo, index)),
            )))
      ]),
    );
  }
}
