import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';

const String apiKey = '1ae7e5e12a8acea4a69085bbe0e73e6a';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const forecastWeatherMapURL = 'https://api.openweathermap.org/data/2.5/onecall';

//Api parser and decoder
class NetworkHelper {
  NetworkHelper(this.url);
  final String url;
  Future<Map<String, dynamic>> getData() async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    response.statusCode == 200
        ? response.body
        : print('${response.statusCode}');
    // throw Exception('Failed to load weather ${response.statusCode}')
    return jsonDecode(response.body);
  }
}

//Get current geoposition from geolocator
class LocationGeopositionData {
  double latitude;
  double longitude;
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } on Exception catch (e) {
      print(e);
      latitude = -76.5532;
      longitude = 22.1228;
    }
  }
}

//Get location/city weather by passing link to NetworkHelper, and retrieving json body
class WeatherDataModel {
  Future<Map<String, dynamic>> getLocationWeatherAPI() async {
    LocationGeopositionData locationGeopositionData = LocationGeopositionData();
    await locationGeopositionData.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherMapURL?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&exclude=current,minutely,hourly,alerts&APPID=$apiKey&units=imperial");
    var weatherData = await networkHelper.getData();
    // print(weatherData);
    return weatherData;
  }

  Future<dynamic> getCityWeatherAPI(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherMapURL?q=$cityName&APPID=$apiKey&units=imperial");
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}

//Loads next 5 days forecast
class WeatherForecast {
  Future<Map<String, dynamic>> getForecastAPI() async {
    LocationGeopositionData locationGeopositionData = LocationGeopositionData();
    await locationGeopositionData.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$forecastWeatherMapURL?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&APPID=$apiKey&units=imperial");

    var weatherForecast = await networkHelper.getData();
    return weatherForecast;
  }

  // "https://api.openweathermap.org/data/2.5/onecall?lat=34.2656&lon=-118.871&APPID=1ae7e5e12a8acea4a69085bbe0e73e6a&units=imperial"

  // Future<Map<String, dynamic>> sevenDaysForecastAPI(dynamic cityName) async {
  //   NetworkHelper networkHelper = NetworkHelper(
  //       "https://api.openweathermap.org/data/2.5/forecast/daily?q=$cityName&cnt=7&appid=7e0bcae076b4db333e125664be2f6d3d");
  //   var weatherForecast = await networkHelper.getData();
  //   // print(weatherForecast);
  //   return weatherForecast;
  // }
}

// This api requires a paid subscription
// class HourlyForecast {
//   Future<Map<String, dynamic>> getHourlyAPI() async {
//     LocationGeopositionData locationGeopositionData = LocationGeopositionData();
//     await locationGeopositionData.getCurrentLocation();
//     NetworkHelper networkHelper = NetworkHelper(
//         "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&APPID=$apiKey&units=imperial");
//
//     var hourlyForecast = await networkHelper.getData();
//     print(hourlyForecast);
//     return hourlyForecast;
//   }
// }

// class WeatherJSON {
//   var dt;
//   var temp;
//   var icon;
//
//   WeatherJSON({this.dt, this.temp, this.icon});
//   factory WeatherJSON.fromJson(Map<String, dynamic> json) {
//     return WeatherJSON(
//       dt: json["list"][0]["dt"] as dynamic,
//       temp: json["list"][0]["main"]["temp"] as dynamic,
//       icon: json["list"][0]["weather"][0]["icon"] as dynamic,
//     );
//   }
// }
//

// Future<void> loadForecast(dynamic weatherData) async {
//   var weatherForecast = await WeatherForecast().getForecastAPI();
//   // setState((){null});
//   var timeStamp = weatherForecast["list"][0]["dt"];
//   var tempStamp = weatherForecast["list"][0]["main"]["temp"];
//   var iconStamp = weatherForecast["list"][0]["weather"][0]["icon"];
//
//   print(timeStamp);
//   print(tempStamp);
//   print(iconStamp);
// }

// /// Returns the difference (in full days) between the provided date and today.
// int calculateDifference(DateTime date) {
//   DateTime now = DateTime.now();
//   return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
// }
