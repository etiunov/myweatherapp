import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:myiphoneweather/utilities/location-api.dart';
import 'package:myiphoneweather/utilities/timer.dart';
import 'package:myiphoneweather/utilities/constrants.dart';
import 'package:myiphoneweather/utilities/background.dart';
import 'package:myiphoneweather/screens/cats_sceen.dart';
import 'package:myiphoneweather/utilities/extracted_widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:myiphoneweather/utilities/alert_dialog.dart';
import 'package:transparent_image/transparent_image.dart';

class IphoneScreen extends StatefulWidget {
  final locationWeather;
  final forecastWeather;
  final cityForecast;
  IphoneScreen({this.locationWeather, this.forecastWeather, this.cityForecast});

  @override
  _IphoneScreenState createState() => _IphoneScreenState();
}

class _IphoneScreenState extends State<IphoneScreen> {
  WeatherDataModel weatherDataModel = WeatherDataModel();
  WeatherForecast weatherForecast = WeatherForecast();
  TimeCounter timeCounter = TimeCounter();
  BackgroundUI backgroundUI = BackgroundUI();

  var hoursList = List(12);
  var weekDayList = List(14);
  List<String> temperatureList = [];
  // var iconList = List(12);
  var minTemperatureList = [];
  var maxTemperatureList = [];

  var cityTemp,
      cityName,
      cityMaxTemp,
      cityMinTemp,
      conditionMessage,
      conditionIcon,
      locationMainTemperature,
      locationMaxTemperature,
      locationMinTemperature,
      locationConditionMessage,
      locationConditionIcon = "01d",
      locationCityName = '--',
      locationDescription,
      locationSunrise,
      locationSunset,
      locationPressure,
      locationHumidity,
      locationWind,
      locationFeelsLike,
      locationWindDeg,
      locationCountry,
      typedCityName;

  @override
  void initState() {
    super.initState();
    backgroundUI.updateBackgroudImage();
    updateUI(widget.locationWeather);
    loadForecast(widget.forecastWeather);
    dayOfWeek();
    timeNow();
  }

  Future<void> timeNow() async {
    var today = DateTime.now();
    for (var i = 0; i < 12; i++) {
      var hours = await DateFormat('ha')
          .format(today.add(Duration(hours: i + 1)))
          .toLowerCase()
          .toString();
      setState(() {
        hoursList[i] = hours;
      });
    }
  }

  //Week days to vertical scroll
  Future<void> dayOfWeek() async {
    var today = DateTime.now();
    for (var i = 0; i < 14; i++) {
      var days = await DateFormat('E')
          .format(today.add(Duration(days: i + 1)))
          .toString();
      setState(() {
        weekDayList[i] = days;
      });
    }
  }

  //Fetch api for weather data to UI
  Future<void> updateUI(dynamic weatherData) async {
    // var weatherData = await WeatherDataModel().getLocationWeatherAPI();
    // var weatherData = await WeatherDataModel().getCityWeatherAPI(locationCityName);
    setState(() {
      locationMainTemperature = weatherData['main']['temp'].toInt();
      locationMaxTemperature = weatherData['main']['temp_max'].toInt();
      locationMinTemperature = weatherData['main']['temp_min'].toInt();
      locationConditionMessage = weatherData['weather'][0]['main'];
      locationConditionIcon = weatherData['weather'][0]['icon'];
      locationCityName = weatherData['name'];
      locationDescription = weatherData['weather'][0]['description'];
      // var timeSunrise = weatherData['sys']['sunrise'];
      locationSunrise = DateFormat('jm').format(
          DateTime.fromMillisecondsSinceEpoch(
              (weatherData['sys']['sunrise']) * 1000));
      // var timeSunset = weatherData['sys']['sunset'];
      locationSunset = DateFormat('jm').format(
          DateTime.fromMillisecondsSinceEpoch(
              (weatherData['sys']['sunset']) * 1000));
      locationPressure = weatherData['main']['pressure'];
      locationHumidity = weatherData['main']['humidity'];
      locationWind = weatherData['wind']['speed'];
      locationFeelsLike = weatherData['main']['feels_like'];
      // var windDeg1 = weatherData['wind']['deg'];
      locationWindDeg = (weatherData['wind']['deg']).toInt();
      locationCountry = weatherData['sys']['country'];
    });
  }

  //Air quality bar
  String airQuality(windDegree) {
    if (windDegree < 100) {
      return 'Good';
    } else if (windDegree < 240) {
      return 'Medium';
    } else {
      return 'High';
    }
  }

  Future<void> loadForecast(dynamic weatherForecast) async {
    var icon = weatherForecast['icon'];

    print(weatherForecast);
  }

  // Future<void> loadForecast(dynamic weatherForecast) async {
  //   var weatherForecast = await WeatherForecast().getForecastAPI();
  //   setState(() {
  //     var timeStamp0 = weatherForecast["list"][0]["dt"];
  //     var dayname0 = DateTime.fromMillisecondsSinceEpoch(timeStamp0);
  //     convertedForecastDate0 = DateFormat('EEEE').format(dayname0);
  //     var tempStamp0 = weatherForecast["list"][0]["main"]["temp"];
  //     convertedTempAPI0 = tempStamp0.toInt();
  //
  //     iconStamp0 = weatherForecast["list"][0]["weather"][0]["icon"];
  //
  //     var timeStamp1 = weatherForecast["list"][1]["dt"];
  //     var dayname1 = DateTime.fromMillisecondsSinceEpoch(timeStamp1 * 1000);
  //     convertedForecastDate1 = DateFormat('EEEE').format(dayname1);
  //     var tempStamp1 = weatherForecast["list"][1]["main"]["temp"];
  //     convertedTempAPI1 = tempStamp1.toInt();
  //     iconStamp1 = weatherForecast["list"][1]["weather"][0]["icon"];
  //
  //     var timeStamp2 = weatherForecast["list"][2]["dt"];
  //     var dayname2 = DateTime.fromMillisecondsSinceEpoch(timeStamp2 * 1000);
  //     convertedForecastDate2 = DateFormat('EEEE').format(dayname2);
  //
  //     var tempStamp2 = weatherForecast["list"][2]["main"]["temp"];
  //     convertedTempAPI2 = tempStamp2.toInt();
  //     iconStamp2 = weatherForecast["list"][2]["weather"][0]["icon"];
  //
  //     var timeStamp3 = weatherForecast["list"][3]["dt"];
  //     var dayname3 = DateTime.fromMillisecondsSinceEpoch(timeStamp3 * 1000);
  //     convertedForecastDate3 = DateFormat('EEEE').format(dayname3);
  //
  //     var tempStamp3 = weatherForecast["list"][3]["main"]["temp"];
  //     convertedTempAPI3 = tempStamp3.toInt();
  //     iconStamp3 = weatherForecast["list"][3]["weather"][0]["icon"];
  //
  //     var timeStamp4 = weatherForecast["list"][4]["dt"];
  //     var dayname4 = DateTime.fromMillisecondsSinceEpoch(timeStamp4 * 1000);
  //     convertedForecastDate4 = DateFormat('EEEE').format(dayname4);
  //     var tempStamp4 = weatherForecast["list"][4]["main"]["temp"];
  //     convertedTempAPI4 = tempStamp4.toInt();
  //     iconStamp4 = weatherForecast["list"][4]["weather"][0]["icon"];
  //
  //     var timeStamp5 = weatherForecast["list"][5]["dt"];
  //     var dayname5 = DateTime.fromMillisecondsSinceEpoch(timeStamp5 * 1000);
  //     convertedForecastDate5 = DateFormat('EEEE').format(dayname5);
  //     var tempStamp5 = weatherForecast["list"][5]["main"]["temp"];
  //     convertedTempAPI5 = tempStamp5.toInt();
  //     iconStamp5 = weatherForecast["list"][5]["weather"][0]["icon"];
  //
  //     var timeStamp6 = weatherForecast["list"][6]["dt"];
  //     var dayname6 = DateTime.fromMillisecondsSinceEpoch(timeStamp6 * 1000);
  //     convertedForecastDate6 = DateFormat('EEEE').format(dayname6);
  //     var tempStamp6 = weatherForecast["list"][6]["main"]["temp"];
  //     convertedTempAPI6 = tempStamp6.toInt();
  //     iconStamp6 = weatherForecast["list"][6]["weather"][0]["icon"];
  //
  //     var timeStamp7 = weatherForecast["list"][7]["dt"];
  //     var dayname7 = DateTime.fromMillisecondsSinceEpoch(timeStamp7 * 1000);
  //     convertedForecastDate7 = DateFormat('EEEE').format(dayname7);
  //     var tempStamp7 = weatherForecast["list"][7]["main"]["temp"];
  //     convertedTempAPI7 = tempStamp7.toInt();
  //     iconStamp7 = weatherForecast["list"][7]["weather"][0]["icon"];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  backgroundUI.backgroundImage,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8),
                  BlendMode.dstATop,
                ),
              ),
            ),
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      onStretchTrigger: () {
                        // Function callback for stretch
                        return Future<void>.value();
                      },
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 100.0,
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const <StretchMode>[
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                          StretchMode.fadeTitle,
                        ],
                        // background:
                        // Image(
                        //   image: AssetImage(
                        //     backgroundUI.backgroundImage,
                        //   ),
                        //   fit: BoxFit.fitWidth,
                        //   alignment: Alignment.topCenter,
                        // ),
                        // background: Stack(
                        //   fit: StackFit.expand,
                        //   children: [
                        //     Image.network(
                        //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                        //       fit: BoxFit.cover,
                        //     ),
                        //     DecoratedBox(
                        //       decoration: BoxDecoration(
                        //         gradient: LinearGradient(
                        //           begin: Alignment(0.0, 0.5),
                        //           end: Alignment(0.0, 0.0),
                        //           colors: <Color>[
                        //             Color(0x60000000),
                        //             Color(0x00000000),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        title: Text(
                          '$locationCityName' ?? '--',
                          style: iPhoneTitleStyle,
                        ),
                        centerTitle: true,
                      ),
                      backwardsCompatibility: false,
                      shadowColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(Icons.near_me),
                        tooltip: 'Get location',
                        onPressed: () async {
                          var weatherDataCall =
                              await weatherDataModel.getLocationWeatherAPI();
                          updateUI(weatherDataCall);
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.location_city),
                          tooltip: 'Add city',
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  title: Text('Enter city name'),
                                  content: TextField(
                                    onSubmitted: (value) async {
                                      typedCityName = value;
                                      Navigator.pop(context);
                                      if (typedCityName != null) {
                                        var weatherData = await weatherDataModel
                                            .getCityWeatherAPI(typedCityName);
                                        updateUI(weatherData);
                                      }
                                      print(typedCityName);
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
                                        Navigator.pop(context, typedCityName);
                                        if (typedCityName != null) {
                                          var weatherData =
                                              await weatherDataModel
                                                  .getCityWeatherAPI(
                                                      typedCityName);
                                          updateUI(weatherData);
                                        }
                                        print(typedCityName);
                                      },
                                      child: Text('Next'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: [
                            Text(
                              '$locationConditionMessage',
                              style: iPhoneTextStyle,
                            ),
                            Text(
                              '$locationMainTemperature°',
                              style: kConditionTextStyle,
                            ),
                            Text(
                              'H:$locationMaxTemperature° L:$locationMinTemperature°',
                              style: iPhoneTextStyle,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: [
                            Divider(
                              thickness: 2.0,
                            ),
                          ],
                        ),
                      ]),
                    ),
                    SliverGrid.count(
                      childAspectRatio: 4.0,
                      crossAxisCount: 1,
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // padding: const EdgeInsets.all(8),
                            itemCount: hoursList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${hoursList[index]}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: Text('${iconList[index]}' ?? 'icon'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('temp'),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Divider(
                            thickness: 2.0,
                          ),
                        ],
                      ),
                    ),
                    SliverGrid.count(
                      childAspectRatio: 1.6,
                      crossAxisCount: 1,
                      children: [
                        ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            // padding: const EdgeInsets.all(8),
                            itemCount: weekDayList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${weekDayList[index]}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('icon'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('Max'),
                                        Text(' '),
                                        Text('Min'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Divider(
                            thickness: 2.0,
                          ),
                          ListTile(
                            title: Text(
                              'Today: $locationDescription. It\'s $locationMainTemperature°; the high today is forecast as $locationMaxTemperature°.',
                              maxLines: 2,
                              softWrap: true,
                              style: iPhoneTextStyle,
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                          ),
                        ],
                      ),
                    ),
                    SliverGrid.count(
                      crossAxisCount: 1,
                      childAspectRatio: 5.0,
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'AIR QUALITY',
                                  style: transTextStyle,
                                ),
                              ),
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'AQI ($locationCountry)',
                                  style: transTextStyle,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '$locationWindDeg - ${airQuality(locationWindDeg)}',
                                style: iPhoneTextStyle1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbColor: Colors.white,
                                      activeTrackColor: Colors.transparent,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0,
                                      ),
                                    ),
                                    child: Slider.adaptive(
                                        value: locationWindDeg.toDouble(),
                                        min: 0.0,
                                        max: 360.0,
                                        onChanged: (double windDeg1) {
                                          setState(() {
                                            print('$locationWindDeg');
                                          });
                                        }),
                                  ),
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [
                                          0.1,
                                          0.4,
                                          0.5,
                                          0.9,
                                        ],
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.red,
                                          Colors.yellow,
                                          Colors.green,
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'SUNRISE',
                                  style: transTextStyle,
                                ),
                              ),
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'SUNSET',
                                  style: transTextStyle,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locationSunrise,
                                style: transTextStyle1,
                              ),
                              Text(
                                locationSunset,
                                style: transTextStyle1,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'PRESSURE',
                                  style: transTextStyle,
                                ),
                              ),
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'HUMIDITY',
                                  style: transTextStyle,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$locationPressure hPa',
                                style: transTextStyle1,
                              ),
                              Text(
                                '$locationHumidity%',
                                style: transTextStyle1,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'WIND',
                                  style: transTextStyle,
                                ),
                              ),
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  'FEELS LIKE',
                                  style: transTextStyle,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$locationWind mPh',
                                style: transTextStyle1,
                              ),
                              Text(
                                '$locationFeelsLike°',
                                style: transTextStyle1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
            )));
  }
}

class DayForecast {
  final String dayName;
  final String iconImage;
  final String maxTemp;
  final String minTemp;

  DayForecast(this.dayName, this.iconImage, this.maxTemp, this.minTemp);

  // Image.network(
  // imageUrl,
  // key: _backgroundImageKey,
  // fit: BoxFit.cover,
  // ),
}

//TODO: Random city name
//TODO: High, Medium, Normal via enum to airquality
//TODO: Slider via colors for airquality
// Container(
// child: Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// DividerWidget(),
// Text(
// 'Today: $description. It\'s $convertedMainTemperature°; the high today is forecast as $convertedMaxTemperature°.',
// maxLines: 2,
// softWrap: true,
// style: iPhoneTextStyle,
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// Divider(
// color: Colors.white24,
// thickness: 1.0,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Opacity(
// opacity: 0.50,
// child: Text(
// 'AIR QUALITY',
// style: transTextStyle,
// ),
// ),
// Opacity(
// opacity: 0.50,
// child: Text(
// 'AQI ($country)',
// style: transTextStyle,
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Text(
// '$windDeg - ${airQuality(windDeg)}',
// style: iPhoneTextStyle1,
// )
// ],
// ),
// ),
// Container(
// child: SliderTheme(
// data: SliderTheme.of(context).copyWith(
// thumbColor: Colors.white,
// activeTrackColor: Colors.white10,
// thumbShape: RoundSliderThumbShape(
// enabledThumbRadius: 8.0,
// ),
// ),
// child: Slider.adaptive(
// value: windDeg.toDouble(),
// min: 0.0,
// max: 360.0,
// onChanged: (double windDeg1) {
// setState(() {
// print('$windDeg');
// });
// }),
// ),
// height: 8.0,
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.all(Radius.circular(8.0)),
// gradient: LinearGradient(
// begin: Alignment.topRight,
// end: Alignment.bottomLeft,
// stops: [
// 0.1,
// 0.4,
// 0.5,
// 0.9,
// ],
// colors: [
// Colors.deepPurple,
// Colors.red,
// Colors.yellow,
// Colors.green,
// ],
// )),
// )
// ],
// ),
// ),
// ExtraDataWidget(
// apitDataLeft: sunrise,
// apiDataRight: sunset,
// titleLeft: 'SUNRISE',
// titleRight: 'SUNSET',
// ),
// ExtraDataWidget(
// apitDataLeft: '$pressure hPa',
// apiDataRight: '$humidity%',
// titleLeft: 'PRESSURE',
// titleRight: 'HUMIDITY',
// ),
// ExtraDataWidget(
// apitDataLeft: '$wind mPh',
// apiDataRight: '$feelsLike°',
// titleLeft: 'WIND',
// titleRight: 'FEELS LIKE',
// ),
// ],
// ),
// ),

// Column(
// children: [
// Container(
// height: 50,
// child: ForecastWidget(
// convertedForecastDate: weekDays[index],
// iconStamp: iconCodes[index],
// convertedTempAPI: temeratures[index]),
// ),
// ],
// );

// return Scaffold(
// body: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage(
// backgroundUI.backgroundImage,
// ),
// fit: BoxFit.cover,
// colorFilter: ColorFilter.mode(
// Colors.white.withOpacity(0.8),
// BlendMode.dstATop,
// ),
// ),
// ),
// constraints: BoxConstraints.expand(),
// child: SafeArea(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Padding(
// padding: EdgeInsets.all(30.0),
// child: Column(
// children: [
// Text(
// '$cityName',
// style: iPhoneTitleStyle,
// ),
// Text(
// '$conditionMainMessage',
// style: iPhoneTextStyle,
// ),
// Text(
// '$convertedMainTemperature°',
// style: iPhoneTempStyle,
// ),
// Text(
// 'H:$convertedMaxTemperature°  L:$convertedMinTemperature°',
// style: iPhoneTextStyle,
// ),
// ],
// ),
// ),
// DividerWidget(),
// Column(
// children: [
// // ListView.builder(
// //   padding: const EdgeInsets.all(8),
// //   scrollDirection: Axis.horizontal,
// //   itemCount: weekDays.length,
// //   itemBuilder: (BuildContext context, int index) {
// //     return Column(
// //       children: [
// //         Container(
// //           height: 50,
// //           child: HourlyWidget(
// //               time: weekDays[index],
// //               iconStamp: iconCodes[index],
// //               convertedTempAPI: temeratures[index]),
// //         ),
// //       ],
// //     );
// //   },
// // ),
// DividerWidget(),
// // Expanded(
// //   // flex: 2,
// //   child: ListView.builder(
// //     padding: const EdgeInsets.all(8),
// //     scrollDirection: Axis.vertical,
// //     itemCount: weekDays.length,
// //     itemBuilder: (BuildContext context, int index) {
// //       return Column(
// //         children: [
// //           Container(
// //             height: 50,
// //             child: ForecastWidget(
// //                 convertedForecastDate: weekDays[index],
// //                 iconStamp: iconCodes[index],
// //                 convertedTempAPI: temeratures[index]),
// //           ),
// //         ],
// //       );
// //     },
// //   ),
// // ),
// DividerWidget(),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: <Widget>[
// TextButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => LoadingScreen()),
// );
// },
// child: Icon(
// Icons.info,
// size: 20.0,
// color: Colors.white,
// ),
// ),
// TextButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => CatsScreen()),
// );
// },
// child: Icon(
// Icons.list,
// size: 20.0,
// color: Colors.white,
// ),
// ),
// ],
// ),
// ],
// )
// ]),
// )));

List<dynamic> temps = [];
// final Size screenSize = MediaQuery.of(context).size;
// final List<String> weekDays = <String>[
//   'Monday',
//   'Tuesday',
//   'Wednesday',
//   'Thursday',
//   'Friday',
//   'Saturday',
//   'Sunday'
// ];
