import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myiphoneweather/utilities/location-api.dart';
import 'package:myiphoneweather/screens/location_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    updateGeoposition();
  }

  //To get weather from api, and send this weather data to UI
  Future<void> updateGeoposition() async {
    var weatherData = await WeatherDataModel().getLocationWeatherAPI();
    var airData = await WeatherDataModel().getAirPollutionAPI();
    var weatherForecast = await WeatherForecast().getForecastAPI();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IphoneScreen(
          locationWeather: weatherData,
          forecastWeather: weatherForecast,
          airPollution: airData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // Stack(
          //   children: <Widget>[
          //     Center(child: CircularProgressIndicator()),
          //     Center(
          //       child: FadeInImage.memoryNetwork(
          //         placeholder: kTransparentImage,
          //         image: 'https://picsum.photos/250?image=9',
          //       ),
          //     ),
          //   ],
          // ),
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100.0,
              // backgroundColor: Colors.white,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/images.gif'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 16.0)
                      ],
                      shape: BoxShape.circle,
                      // gradient: LinearGradient(
                      //     begin: Alignment.centerLeft,
                      //     end: Alignment.centerRight,
                      //     colors: [Colors.purple, Colors.red]),
                    ),
                    alignment: Alignment.center,
                    // child: Text(
                    //   'Weather Me°',
                    //   style: TextStyle(
                    //       fontSize: 30,
                    //       fontFamily: 'Source Sans Pro',
                    //       color: Colors.white),
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
