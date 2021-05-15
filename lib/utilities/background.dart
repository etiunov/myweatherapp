import 'package:flutter/material.dart';
import 'dart:math';

//Background picture vs day time
class BackgroundUI {
  String backgroundImage;

  String updateBackgroudImage() {
    List<String> _backgroundDayImage = [
      'images/sunny.gif',
      'images/rain.gif',
      'images/suncity.gif',
    ];
    List<String> _backgroundRiseImage = [
      'images/sunset.gif',
    ];
    List<String> _backgroundNightImage = [
      'images/night.gif',
      'images/nightcity.gif',
    ];

    var rndDayPicture = Random().nextInt(3);
    var rndRisePicture = Random().nextInt(1);
    var rndNightPicture = Random().nextInt(2);

    if (TimeOfDay.now().hour >= 8 && TimeOfDay.now().hour <= 17) {
      return backgroundImage = _backgroundDayImage[rndDayPicture];
    } else if ((TimeOfDay.now().hour >= 17 && TimeOfDay.now().hour <= 20) ||
        (TimeOfDay.now().hour >= 5 && TimeOfDay.now().hour <= 8)) {
      return backgroundImage = _backgroundRiseImage[rndRisePicture];
    } else {
      return backgroundImage = _backgroundNightImage[rndNightPicture];
    }
  }
}
