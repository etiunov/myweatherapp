import 'package:flutter/material.dart';
import 'dart:core';
import 'package:myiphoneweather/utilities/constrants.dart';

class HourlyWidget extends StatelessWidget {
  const HourlyWidget({
    Key key,
    @required this.time,
    @required this.iconStamp,
    @required this.convertedTempAPI,
  }) : super(key: key);

  final String time;
  final String iconStamp;
  final int convertedTempAPI;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          time,
        ),
        Image(
          image: NetworkImage(
              'https://openweathermap.org/img/wn/${iconStamp ?? "01d"}.png'),
        ),
        Text('$convertedTempAPI°'),
      ],
    );
  }
}

class ExtraDataWidget extends StatelessWidget {
  const ExtraDataWidget({
    Key key,
    @required this.apitDataLeft,
    @required this.apiDataRight,
    @required this.titleLeft,
    @required this.titleRight,
  }) : super(key: key);

  final String apitDataLeft;
  final String apiDataRight;
  final String titleLeft;
  final String titleRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            color: Colors.white24,
            thickness: 1.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.50,
                child: Text(
                  titleLeft,
                  style: transTextStyle,
                ),
              ),
              Opacity(
                opacity: 0.50,
                child: Text(
                  titleRight,
                  style: transTextStyle,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$apitDataLeft',
                style: iPhoneTextStyle,
              ),
              Text(
                '$apiDataRight',
                style: iPhoneTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white24,
      thickness: 1.0,
    );
  }
}

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    Key key,
    @required this.convertedForecastDate,
    @required this.iconStamp,
    @required this.convertedTempAPI,
  }) : super(key: key);

  final String convertedForecastDate;
  final String iconStamp;
  final int convertedTempAPI;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '$convertedForecastDate',
          style: iPhoneTextStyle,
        ),
        Image(
          image: NetworkImage(
              'https://openweathermap.org/img/wn/${iconStamp ?? "01d"}.png'),
        ),
        Row(
          children: [
            Text(
              '$convertedTempAPI°',
              style: iPhoneTextStyle,
            ),
            Container(
              width: 10,
            ),
            Opacity(
              opacity: 0.40,
              child: Text(
                '$convertedTempAPI°',
                style: iPhoneTextStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
