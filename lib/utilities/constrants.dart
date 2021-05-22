import 'package:flutter/material.dart';

const dividerLine = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.white24),
  ),
);

const dividerDoubleLine = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.white24),
    bottom: BorderSide(color: Colors.white24),
  ),
);

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
  fontSize: 34.0,
  fontFamily: 'Roboto',
  // fontWeight: FontWeight.w400,
);

const iPhoneTextStyle1 = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 20.0,
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
