// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// enum DialogAction { yes, cancel }
// String locationCityName;
//
// class AlertDialogs {
//   String locationCityName;
//   Future<dynamic> yesCancelDialog(
//     BuildContext context,
//     String title,
//     Widget textField,
//   ) async {
//     final action = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             title: Text(title),
//             content: TextField(
//               onSubmitted: (value) {
//                 locationCityName = value;
//                 Navigator.pop(context, locationCityName);
//               },
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () => Navigator.pop(context, locationCityName),
//                   child: Text('Next')),
//             ],
//           );
//         });
//   }
// }
//
// final formKey = GlobalKey<FormState>();
// final textField = TextFormField(
//   decoration: InputDecoration(hintText: 'Enter city name'),
//   onFieldSubmitted: (value) {
//     locationCityName = value;
//   },
//   validator: (value) {
//     if (value.isEmpty) {
//       return 'Please enter a city name';
//     }
//     return null;
//   },
// );
