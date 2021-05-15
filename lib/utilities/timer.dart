import 'dart:core';
import 'package:intl/intl.dart';

//To display day name in forecast list
class TimeCounter {
  TimeCounter({this.timestamp});
  final timestamp;
  var dayOfWeek;
  int daysPerWeek;
  String day;

  String updateDays() {
    dayOfWeek = DateTime.now();
    dayOfWeek = DateFormat('EEEE').format(dayOfWeek);
    daysPerWeek = DateTime.daysPerWeek;
    print(dayOfWeek);
    // print(daysPerWeek);
    return dayOfWeek;
  }

  dynamic updateHours(var timestamp) {
    var timestamp = 1406080800;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    day = DateFormat('EEEE').format(date);
    // var next = day.add(day: 1);
    return day;
  }

  void getDayHours() {
    var cur = DateTime.now();
    for (cur; cur.hour < 5; cur.hour + 1) {
      print(cur);
    }
  }

  // void time() {
  //   // setState(() {
  //   // var cHrs = DateTime.now().add(Duration(hours: n)).hour;
  //   var cHrs = DateTime.now();
  //   var cHrs1 = DateFormat.j(cHrs);
  //   var cHrs2 = DateFormat('j').format(cHrs);
  //   print(cHrs1);
  //   print(cHrs2);
  //   // var cHrs2 = cHrs1.;
  //   // var currTimeToHrs = cHrs.hour;
  //   // return cHrs1;
  //   // });
  // }

}
