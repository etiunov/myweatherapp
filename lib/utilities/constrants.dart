import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 54.0,
);

const kButtonTextStyle =
    TextStyle(fontSize: 30.0, fontFamily: 'Spartan MB', color: Colors.white);

const kConditionTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontFamily: 'Spartan MB',
  fontSize: 80.0,
);

const iPhoneTitleStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 24.0,
  fontFamily: 'Roboto',
  // fontWeight: FontWeight.w400,
);
const iPhoneTextStyle1 = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 16.0,
  // fontFamily: 'Roboto',
);
const transTextStyle = TextStyle(
  fontSize: 16.0,
  // fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
);

const transTextStyle1 = TextStyle(
  fontSize: 24.0,
  // fontFamily: 'Roboto',
  // fontWeight: FontWeight.w300,
);

const iPhoneTextStyle = TextStyle(
  fontSize: 20.0,
  // fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
);

const iPhoneTempStyle = TextStyle(
  fontSize: 100.0,
  // fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
);

const textFieldStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(
        10.0,
      ),
    ),
    borderSide: BorderSide.none,
  ),
);

const String apiKey = '1ae7e5e12a8acea4a69085bbe0e73e6a';

const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
