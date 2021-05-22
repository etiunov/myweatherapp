import 'package:flutter/material.dart';
import 'package:myiphoneweather/screens/location_screen.dart';
import 'package:myiphoneweather/utilities/location-api.dart';

class CityScreen extends StatefulWidget {
  final locationWeather;

  CityScreen({
    this.locationWeather,
  });

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  WeatherDataModel weatherDataModel = WeatherDataModel();
  var locationCityName, locationMainTemperature;
  var cityList = [];
  var tempCityList = [];

  @override
  void initState() {
    updateThisUI(widget.locationWeather);
  }

  Future<void> updateThisUI(dynamic weatherData) async {
    setState(() {
      locationMainTemperature = weatherData['main']['temp'].toInt();
      locationCityName = weatherData['name'];
      cityList.add(locationCityName);
      tempCityList.add(locationMainTemperature);
    });
    print(cityList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Info',
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text('Enter city name'),
                    content: TextField(
                      onSubmitted: (value) async {
                        locationCityName = value;
                        Navigator.pop(context);
                        if (locationCityName != null) {
                          var weatherData = await weatherDataModel
                              .getCityWeatherAPI(locationCityName);
                          updateThisUI(weatherData);
                        }
                      },
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context, locationCityName);
                          if (locationCityName != null) {
                            var weatherData = await weatherDataModel
                                .getCityWeatherAPI(locationCityName);
                            updateThisUI(weatherData);
                          }
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: Text('City Screen'),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: cityList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                // tileColor: Colors.blueAccent,
                onTap: () async {
                  Navigator.pop(context, locationCityName);
                  if (locationCityName != null) {
                    var weatherData = await weatherDataModel
                        .getCityWeatherAPI(locationCityName);
                    updateThisUI(weatherData);
                  }
                },
                leading: Text('${tempCityList[index]}°',
                    style: Theme.of(context).textTheme.headline3),
                title: Text('${cityList[index]}',
                    style: Theme.of(context).textTheme.headline4),
              );
            },
          ),
        ),
      ),
    );
  }
}
