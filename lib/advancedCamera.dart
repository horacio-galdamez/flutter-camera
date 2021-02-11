import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart'; 

import './reviewImages.dart';

void main() => runApp(AdvancedCamera());

class AdvancedCamera extends StatefulWidget {
  static final String route = "/advanced-camera";
  @override
  _AdvancedCameraState createState() => _AdvancedCameraState();
}

class _AdvancedCameraState extends State<AdvancedCamera> {
  List<File> _photos = [];
  String _firstButtonText = 'Take photo';
  String _secondButtonText = 'Choose from Gallery';
  double _textSize = 20;
  bool _hasChosenMode = false;
  bool _isCameraMode = false;

  @override
  void initState() {
    super.initState();
  }

  _takePhotosPerPage({bool isCameraMode}) async {
    setState(() {
      _hasChosenMode = true;
      _isCameraMode = isCameraMode;
    });

    await _takePhoto(isCameraMode: _isCameraMode);
  }

  Future<File> _takePhoto({bool isCameraMode}) async {
    var returnedImage;
    var source = isCameraMode ? ImageSource.camera : ImageSource.gallery;

    await ImagePicker.pickImage(source: source).then((selectedImage) {
      returnedImage = selectedImage;
      if (selectedImage != null && selectedImage.path != null) {
        setState(() {
          _firstButtonText = 'saving in progress...';
        });
        _cropImage(selectedImage, _photos);
      }
    });

    return returnedImage;
  }

  void _cropImage(photo, photos) async {
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

    GallerySaver.saveImage(croppedFile.path);

    if (_isCameraMode) {
      setState(() {
        _photos.add(croppedFile);
        _firstButtonText = 'Take next picture';
        _secondButtonText = 'I am done';
      });
    } else {
      setState(() {
        _photos.add(croppedFile);
        _firstButtonText = 'I am done';
        _secondButtonText = 'Choose next picture';
      });
    }
  }

  void _displayGrid() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReviewImages(_photos,
                callback: (val) => setState(() => _photos = val))));
  }

  void _saveNetworkImage() async {
    String path = 'https://URL-to-image.com';
    GallerySaver.saveImage(path).then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: SizedBox.expand(
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => !_hasChosenMode || _isCameraMode
                      ? _takePhotosPerPage(isCameraMode: true)
                      : _displayGrid(),
                  child: Text(_firstButtonText,
                      style:
                          TextStyle(fontSize: _textSize, color: Colors.white)),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
                child: SizedBox.expand(
              child: RaisedButton(
                color: Colors.white,
                onPressed: () => !_hasChosenMode || !_isCameraMode
                    ? _takePhotosPerPage(isCameraMode: false)
                    : _displayGrid(),
                child: Text(_secondButtonText,
                    style:
                        TextStyle(fontSize: _textSize, color: Colors.blueGrey)),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
