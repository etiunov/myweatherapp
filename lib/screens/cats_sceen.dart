import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatsScreen extends StatefulWidget {
  @override
  _CatsScreenState createState() => _CatsScreenState();
}

class _CatsScreenState extends State<CatsScreen> {
  // Let us break down the above function to better understand it. First, we declare a variable “jsonData” which will be set to the JSON object which we will GET using the HTTP package.
  // Once we have the JSON data fetched, we will need to decode it using the default  ‘dart:convert‘ package. Then, once the JSON data is decoded, we can use it to store the result in a list. As you can see we have declared two Lists. The first list which is called “data” will store the JSON objects after decoding. The second list called which is called “imagesUrl” is where we will add all the image URLs read from JSON objects. We will use these image URLs to display images. Next, we will use the “forEach()” function to loop through a collection of JSON objects stored in the “data” list, and for each element, we will read its “URL” property and add its value to a “imagesUrl” list. In the end, we simply return “Success” to close the function.
  List data;
  List imagesUrl = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<String> fetchDataFromApi() async {
    var jsonData = await http.get(Uri.parse(
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/tutorials/files/cats.json"));
    var fetchData = jsonDecode(jsonData.body);

    setState(() {
      data = fetchData;
      data.forEach((element) {
        imagesUrl.add(element['url']);
      });
    });

    return "Success";
  }

  //Inside the GridView.builder we pass the required gridDelegate property and then we give it a SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) which basically means that we want to display our images in 2 columns. Next, the itemCount property is set the length of the imagesUrl list. Finally, in the itemBuilder we return a network image that has a URL path set to imagesUrl[index]. This means we will get one image for every URL stored in the imagesUrl list.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('List Of Images'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: imagesUrl.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imagesUrl[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
