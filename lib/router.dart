import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as fluro;

import './advancedCamera.dart';
import './reviewImages.dart';

class FluroRouter {
  static fluro.Router router = fluro.Router();
  static fluro.Handler _advancedCameraHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AdvancedCamera());
  static fluro.Handler _reviewImageslHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ReviewImages(params["photos"]));

  static void setupRouter() {
    router.define(
      AdvancedCamera.route,
      handler: _advancedCameraHandler,
      transitionType: fluro.TransitionType.material,
    );
    router.define(
      ReviewImages.route,
      handler: _reviewImageslHandler,
      transitionType: fluro.TransitionType.material,
    );
  }
}