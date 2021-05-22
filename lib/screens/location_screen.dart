import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myiphoneweather/utilities/location-api.dart';
import 'package:myiphoneweather/utilities/constrants.dart';
import 'package:myiphoneweather/utilities/background.dart';
import 'package:myiphoneweather/screens/city_screen.dart';

enum OpacityLevel {
  active,
  inactive,
}

class IphoneScreen extends StatefulWidget {
  final locationWeather;
  final forecastWeather;
  final cityForecast;
  final airPollution;
  IphoneScreen(
      {this.locationWeather,
      this.forecastWeather,
      this.cityForecast,
      this.airPollution});

  @override
  _IphoneScreenState createState() => _IphoneScreenState();
}

class _IphoneScreenState extends State<IphoneScreen> {
  WeatherDataModel weatherDataModel = WeatherDataModel();
  WeatherForecast weatherForecast = WeatherForecast();
  BackgroundUI backgroundUI = BackgroundUI();

  ScrollController controller = ScrollController();
  bool closeThisContainer = false;
  double topListItem = 0;
  bool isVisible = true;
  bool isTransparent = false;

  List<dynamic> hoursList = List(12),
      weekDayList = List(7),
      dailyIconList = List(7),
      minTemperatureList = List(7),
      maxTemperatureList = List(7),
      hourlyIconList = List(12),
      hourlyTempList = List(12);

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
      typedCityName,
      airPollutionIndex,
      chanceOfRain,
      precipitation,
      visibility,
      uvIndex;
  double opacityLevel = 1.0;
  Opacity selectedOpacity;

  @override
  void initState() {
    super.initState();
    backgroundUI.updateBackgroudImage();
    updateUI(widget.locationWeather);
    loadForecast(widget.forecastWeather);
    airPollutionUI(widget.airPollution);
    dayOfWeek();
    loadIndexes(widget.forecastWeather);
    timeNow();
    _changeOpacity();
    controller.addListener(() {
      double value = controller.offset / 100;
      setState(() {
        topListItem = value;
        closeThisContainer = controller.offset > 50;
      });
    });
  }

  //Hours list for horizontal scroll
  Future<void> timeNow() async {
    var today = DateTime.now();
    for (var i = 0; i < 12; i++) {
      var hours = DateFormat('ha')
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
    for (var i = 0; i < 7; i++) {
      var days = DateFormat('EEEE')
          .format(today.add(Duration(days: i + 1)))
          .toString();
      setState(() {
        weekDayList[i] = days;
      });
    }
  }

  //Fetch api for weather data to UI
  Future<void> updateUI(dynamic weatherData) async {
    setState(() {
      locationMainTemperature = weatherData['main']['temp'].toInt();
      locationMaxTemperature = weatherData['main']['temp_max'].toInt();
      locationMinTemperature = weatherData['main']['temp_min'].toInt();
      locationConditionMessage = weatherData['weather'][0]['main'];
      locationConditionIcon = weatherData['weather'][0]['icon'];
      locationCityName = weatherData['name'];
      locationDescription = weatherData['weather'][0]['description'];
      locationSunrise = DateFormat('jm').format(
          DateTime.fromMillisecondsSinceEpoch(
              (weatherData['sys']['sunrise']) * 1000));
      locationSunset = DateFormat('jm').format(
          DateTime.fromMillisecondsSinceEpoch(
              (weatherData['sys']['sunset']) * 1000));
      locationPressure = weatherData['main']['pressure'];
      locationHumidity = weatherData['main']['humidity'];
      locationWind = weatherData['wind']['speed'];
      locationFeelsLike = weatherData['main']['feels_like'].toInt();
      locationWindDeg = (weatherData['wind']['deg']).toInt();
      locationCountry = weatherData['sys']['country'];
    });
  }

  //Air pollution index
  Future<void> airPollutionUI(dynamic pollutionData) async {
    setState(() {
      airPollutionIndex = pollutionData["list"][0]["main"]["aqi"];
    });
  }

  //Air quality bar
  String airQuality() {
    if (airPollutionIndex == 1) {
      return 'Good';
    } else if (airPollutionIndex == 2) {
      return 'Fair';
    } else if (airPollutionIndex == 3) {
      return 'Moderate';
    } else if (airPollutionIndex == 4) {
      return 'Poor';
    } else {
      return 'Very Poor';
    }
  }

  //Load additional indexes
  Future<void> loadIndexes(dynamic weatherForecast) async {
    setState(() {
      precipitation = weatherForecast["minutely"][0]["precipitation"];
      var visibilityConv = weatherForecast["current"]["visibility"].toInt();
      visibility = (visibilityConv / 1000).toInt();
      uvIndex = weatherForecast["current"]["uvi"].toInt();
      var confidenceForecast = 0.5;
      chanceOfRain = (precipitation.toInt() * confidenceForecast).toInt();
    });
  }

  //Forecast for next 7 days and 12 hours
  Future<void> loadForecast(dynamic weatherForecast) async {
    for (var i = 0; i < 7; i++) {
      var icon = weatherForecast["daily"][i]["weather"][0]["icon"];
      var tempMax = weatherForecast["daily"][i]["temp"]["max"].toInt();
      var tempMin = weatherForecast["daily"][i]["temp"]["min"].toInt();
      setState(() {
        dailyIconList[i] = icon;
        maxTemperatureList[i] = tempMax;
        minTemperatureList[i] = tempMin;
      });
    }
    for (var i = 0; i < 12; i++) {
      var iconHours = weatherForecast["hourly"][i]["weather"][0]["icon"];
      var temperatureHours = weatherForecast["hourly"][i]["temp"].toInt();
      setState(() {
        hourlyIconList[i] = iconHours;
        hourlyTempList[i] = temperatureHours;
      });
    }
  }

  void _changeOpacity() {
    setState(() {
      // if (opacityLevel == 1.0) {
      //   opacityLevel = 0.5;
      // } else {
      //   opacityLevel = 1.0;
      // }
      opacityLevel == 1.0 ? opacityLevel = 0.5 : opacityLevel = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CircularProgressIndicator()),
        Container(
          // color: Colors.black12,
          child: Image.asset(
            backgroundUI.backgroundImage,
            fit: BoxFit.cover,
          ),
          //TODO Add random city
          // child: Image.network(
          //   'https://loving-newyork.com/wp-content/uploads/2018/09/Empire-State-Building-New-York_160914155540010-e1537863672134.jpg',
          //   fit: BoxFit.cover,
          // ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 100.0,
                leading: IconButton(
                  icon: Icon(Icons.near_me),
                  color: Colors.transparent,
                  onPressed: () {},
                ),
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                title: Column(
                  children: [
                    Text(
                      '$locationCityName' ?? '--',
                      style: iPhoneTitleStyle,
                    ),
                    Text(
                      '$locationConditionMessage',
                      style: iPhoneTextStyle1,
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              // backgroundColor: Colors.transparent,
              body: SafeArea(
                child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '$locationMainTemperature°',
                                  style: kConditionTextStyle,
                                ),
                                Text(
                                  'H:$locationMaxTemperature° L:$locationMinTemperature°',
                                  style: iPhoneTextStyle,
                                ),
                                const SizedBox(
                                  height: 40.0,
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: Delegate(
                          hoursList: hoursList,
                          hourlyIconList: hourlyIconList,
                          hourlyTempList: hourlyTempList,
                          delegateChild: Container(
                            decoration: dividerDoubleLine,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8.0),
                                itemCount: hoursList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          '${hoursList[index]}',
                                          style: iPhoneTextStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Image.network(
                                          'https://openweathermap.org/img/wn/${hourlyIconList[index]}.png',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          '${hourlyTempList[index]}°',
                                          style: iPhoneTextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ),
                      SliverGrid.count(
                        childAspectRatio: 1.1,
                        crossAxisCount: 1,
                        children: [
                          ListView.builder(
                              controller: controller,
                              physics: BouncingScrollPhysics(),
                              itemCount: weekDayList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, right: 24.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${weekDayList[index]}',
                                          style: iPhoneTextStyle,
                                        ),
                                      ),
                                      Image.network(
                                        'https://openweathermap.org/img/wn/${dailyIconList[index]}.png',
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${maxTemperatureList[index]}',
                                              style: iPhoneTextStyle,
                                            ),
                                            SizedBox(width: 10),
                                            Opacity(
                                              opacity: 0.50,
                                              child: Text(
                                                '${minTemperatureList[index]}',
                                                style: iPhoneTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                      SliverGrid.count(
                        crossAxisCount: 1,
                        childAspectRatio: 5.0,
                        children: [
                          Container(
                            decoration: dividerLine,
                            child: ListTile(
                              title: Text(
                                'Today: $locationDescription. It\'s $locationMainTemperature°; the high today is forecast as $locationMaxTemperature°.',
                                maxLines: 2,
                                softWrap: true,
                                style: iPhoneTextStyle,
                              ),
                            ),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    '$airPollutionIndex - ${airQuality()}',
                                    style: iPhoneTextStyle,
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
                                            value: airPollutionIndex.toDouble(),
                                            min: 0.0,
                                            max: 5.0,
                                            onChanged: (double windDeg1) {
                                              setState(() {
                                                // print('$airPollutionIndex');
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
                                              0.2,
                                              0.4,
                                              0.7,
                                              0.8,
                                              0.9,
                                            ],
                                            colors: [
                                              Colors.blueGrey,
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
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTileWidget(
                                leftHeader: 'SUNRISE',
                                rightHeader: 'SUNSET',
                                leftData: locationSunrise,
                                rightData: locationSunset),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTileWidget(
                                leftHeader: 'CHANCE OF RAIN',
                                rightHeader: 'HUMIDITY',
                                leftData: '$chanceOfRain %',
                                rightData: '$locationHumidity%'),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTileWidget(
                                leftHeader: 'WIND',
                                rightHeader: 'FEELS LIKE',
                                leftData: '$locationWind mPh',
                                rightData: '$locationFeelsLike°'),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTileWidget(
                                leftHeader: 'PRECIPITATION',
                                rightHeader: 'PRESSURE',
                                leftData: '$precipitation in',
                                rightData: '$locationPressure inHg'),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTileWidget(
                                leftHeader: 'VISIBILITY',
                                rightHeader: 'UV INDEX',
                                leftData: '$visibility mi',
                                rightData: '$uvIndex'),
                          ),
                          Container(
                            decoration: dividerLine,
                            child: ListTile(
                              title: RichText(
                                  text: TextSpan(
                                      style: transTextStyle,
                                      children: [
                                    TextSpan(
                                        text:
                                            'Weather for $locationCityName city. '),
                                    TextSpan(
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        text: "Open in Maps.",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            var url = "https://www.youtube.com";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          }),
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.transparent,
                child: Container(
                  decoration: dividerLine,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.article_sharp),
                        tooltip: 'Info',
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                title: Text('Weather Info'),
                                content: Text(
                                    'Weather Me° (NonCommercial) is my attempt to repeat The iPhone Weather Channel App to cover the Section 13: Clima - Powering Your Flutter App with Live Web Data of the Complete Flutter App Development Bootcamp with Dart.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Spacer(),
                      IconButton(
                        iconSize: 18.0,
                        icon: Icon(Icons.near_me),
                        tooltip: 'Get location',
                        onPressed: () async {
                          var weatherDataCall =
                              await weatherDataModel.getLocationWeatherAPI();
                          updateUI(weatherDataCall);
                        },
                      ),
                      AnimatedOpacity(
                        duration: const Duration(microseconds: 10),
                        child: IconButton(
                          iconSize: 12.0,
                          icon: Icon(Icons.circle),
                          onPressed: () {
                            _changeOpacity();
                          },
                        ),
                        opacity: opacityLevel,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () async {
                          var weatherData =
                              await WeatherDataModel().getLocationWeatherAPI();
                          var typedCityName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CityScreen(locationWeather: weatherData);
                              },
                            ),
                          );
                          if (typedCityName != null) {
                            var weatherData = await weatherDataModel
                                .getCityWeatherAPI(typedCityName);
                            updateUI(weatherData);
                          }
                          print(typedCityName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final String leftHeader;
  final String rightHeader;
  final String leftData;
  final String rightData;
  ListTileWidget(
      {this.leftHeader, this.rightHeader, this.leftData, this.rightData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Opacity(
              opacity: 0.50,
              child: Text(
                leftHeader,
                style: transTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: 0.50,
              child: Text(
                rightHeader,
                style: transTextStyle,
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              leftData,
              style: transTextStyle1,
            ),
          ),
          Expanded(
            child: Text(
              rightData,
              style: transTextStyle1,
            ),
          ),
        ],
      ),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final dynamic hoursList;
  final dynamic hourlyIconList;
  final dynamic hourlyTempList;
  final Widget delegateChild;

  Delegate({
    this.hoursList,
    this.hourlyIconList,
    this.hourlyTempList,
    this.delegateChild,
  });

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: Colors.grey[850],
        child: delegateChild,
      );

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
