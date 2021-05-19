import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  TimeCounter timeCounter = TimeCounter();
  BackgroundUI backgroundUI = BackgroundUI();

  List<dynamic> hoursList = List(12);
  List<dynamic> weekDayList = List(7);
  List<String> temperatureList = [];
  List<String> dailyIconList = List(7);
  var minTemperatureList = List(7);
  var maxTemperatureList = List(7);
  List<String> hourlyIconList = List(12);
  var hourlyTempList = List(12);

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
      airPollutionIndex;

  @override
  void initState() {
    super.initState();
    backgroundUI.updateBackgroudImage();
    updateUI(widget.locationWeather);
    loadForecast(widget.forecastWeather);
    airPollutionUI(widget.airPollution);
    dayOfWeek();
    timeNow();
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

    print(airPollutionIndex);
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CircularProgressIndicator()),
        Container(
          child: Image.asset(
            backgroundUI.backgroundImage,
            fit: BoxFit.cover,
          ),
          //TODO Add random city
          // Image.network(
          //   'https://loving-newyork.com/wp-content/uploads/2018/09/Empire-State-Building-New-York_160914155540010-e1537863672134.jpg'),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Scaffold(
              backgroundColor: Colors.black12,
              body: SafeArea(
                child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      // SliverToBoxAdapter(
                      //   child: Center(child: CircularProgressIndicator()),
                      // ),
                      SliverAppBar(
                        elevation: 0,
                        stretch: true,
                        onStretchTrigger: () {
                          // Function callback for stretch
                          return Future<void>.value();
                        },
                        pinned: true,
                        primary: true,
                        backgroundColor: Colors.transparent,
                        expandedHeight: 120.0,
                        flexibleSpace: Center(
                          child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Container(
                              color: Colors.transparent,
                            ),
                            stretchModes: const <StretchMode>[
                              StretchMode.zoomBackground,
                              StretchMode.blurBackground,
                              StretchMode.fadeTitle,
                            ],
                            // background: Stack(
                            //   fit: StackFit.expand,
                            //   children: [
                            //     // Image.asset(
                            //     //   backgroundUI.backgroundImage,
                            //     //   fit: BoxFit.cover,
                            //     // ),
                            //     Positioned.fill(
                            //       child: BackdropFilter(
                            //         filter: ImageFilter.blur(
                            //             sigmaX: 3.0, sigmaY: 3.0),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // background: Image(
                            //   image:
                            //   AssetImage(
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
                            icon: Icon(Icons.add),
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
                                          var weatherData =
                                              await weatherDataModel
                                                  .getCityWeatherAPI(
                                                      typedCityName);
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
                      // SliverToBoxAdapter(
                      //   child: SizedBox(
                      //     height: 1000,
                      //     child: Placeholder(),
                      //   ),
                      // ),
                      // SliverPersistentHeader(
                      //   pinned: true,
                      //   floating: false,
                      //   delegate: Delegate(
                      //     delegateChild: Center(
                      //       child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               '$locationCityName' ?? '--',
                      //               style: iPhoneTitleStyle,
                      //             ),
                      //             Text(
                      //               '$locationConditionMessage',
                      //               style: iPhoneTextStyle1,
                      //             ),
                      //           ]),
                      //     ),
                      //   ),
                      // ),
                      SliverList(
                        //https://www.youtube.com/watch?v=Cn6VCTaHB-k&ab_channel=RetroPortalStudio
                        delegate: SliverChildListDelegate([
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$locationConditionMessage',
                                    style: iPhoneTextStyle1,
                                  ),
                                  Text(
                                    '$locationMainTemperature°',
                                    style: kConditionTextStyle,
                                  ),
                                  Text(
                                    'H:$locationMaxTemperature° L:$locationMinTemperature°',
                                    style: iPhoneTextStyle,
                                  ),
                                ],
                              ),
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
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                                bottom: BorderSide(color: Colors.white24),
                              ),
                            ),
                            child: ListView.builder(
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
                              // padding: const EdgeInsets.all(8),
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
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                              ),
                            ),
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
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                              ),
                            ),
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
                                                print('$airPollutionIndex');
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
                                              0.3,
                                              0.4,
                                              0.7,
                                              0.8,
                                              0.9,
                                            ],
                                            colors: [
                                              Colors.brown,
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
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                              ),
                            ),
                            child: ListTileWidget(
                                leftHeader: 'SUNRISE',
                                rightHeader: 'SUNSET',
                                leftData: locationSunrise,
                                rightData: locationSunset),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                              ),
                            ),
                            child: ListTileWidget(
                                leftHeader: 'PRESSURE',
                                rightHeader: 'HUMIDITY',
                                leftData: '$locationPressure hPa',
                                rightData: '$locationHumidity%'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white24),
                                bottom: BorderSide(color: Colors.white24),
                              ),
                            ),
                            child: ListTileWidget(
                                leftHeader: 'WIND',
                                rightHeader: 'FEELS LIKE',
                                leftData: '$locationWind mPh',
                                rightData: '$locationFeelsLike°'),
                          ),
                        ],
                      ),
                    ]),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  selectedIconTheme: IconThemeData(color: Colors.white),
                  unselectedIconTheme: IconThemeData(color: Colors.white),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  items: const <BottomNavigationBarItem>[
                    // IconButton(
                    //   icon: Icon(Icons.near_me),
                    //   tooltip: 'Get location',
                    //   onPressed: () async {
                    //     var weatherDataCall =
                    //         await weatherDataModel.getLocationWeatherAPI();
                    //     updateUI(weatherDataCall);
                    //   },
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.near_me),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: '',
                    ),
                  ]),
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
        child: delegateChild,
      );

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

//TODO: Random city name
