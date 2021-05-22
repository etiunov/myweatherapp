import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';

const String apiKey = '1ae7e5e12a8acea4a69085bbe0e73e6a';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const forecastWeatherMapURL = 'https://api.openweathermap.org/data/2.5/onecall';
const airPollutionURL = 'https://api.openweathermap.org/data/2.5/air_pollution';

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

//Location/city weather
class WeatherDataModel {
  //Source:https://openweathermap.org/current
  Future<Map<String, dynamic>> getLocationWeatherAPI() async {
    LocationGeopositionData locationGeopositionData = LocationGeopositionData();
    await locationGeopositionData.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherMapURL?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&exclude=current,minutely,hourly,alerts&APPID=$apiKey&units=imperial");
    var weatherData = await networkHelper.getData();
    // print(weatherData);
    return weatherData;
  }

  //Source:https://openweathermap.org/current
  Future<dynamic> getCityWeatherAPI(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        "$openWeatherMapURL?q=$cityName&APPID=$apiKey&units=imperial");
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  //Source: https://openweathermap.org/api/air-pollution
  Future<dynamic> getAirPollutionAPI() async {
    LocationGeopositionData locationGeopositionData = LocationGeopositionData();
    await locationGeopositionData.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$airPollutionURL?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&APPID=$apiKey");
    var pollutionData = await networkHelper.getData();
    return pollutionData;
  }
}

//Next 7 days forecast, Source: https://openweathermap.org/api/one-call-api
class WeatherForecast {
  Future<Map<String, dynamic>> getForecastAPI() async {
    LocationGeopositionData locationGeopositionData = LocationGeopositionData();
    await locationGeopositionData.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        "$forecastWeatherMapURL?lat=${locationGeopositionData.latitude}&lon=${locationGeopositionData.longitude}&APPID=$apiKey&units=imperial");
    var weatherForecast = await networkHelper.getData();
    // print(weatherForecast);
    return weatherForecast;
  }
}
