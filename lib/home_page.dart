import 'package:flutter/material.dart';
import 'package:havadurumu/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehir = 'Ankara';
  int? sicaklik;
  // ignore: prefer_typing_uninitialized_variables
  var locationData;
  // ignore: prefer_typing_uninitialized_variables
  var woeid=5;

  Future<void> getLocationTemperature() async {
    var response = await http
        .get(Uri.parse('https://www.metaweather.com/api/location/$woeid/'));
    var temperatureDataParsed = jsonDecode(response.body);
    // ignore: unused_local_variable
    // sicaklik = temperatureDataParsed['consolidated_weather'][0]['the_temp'];
    setState(() {
       sicaklik = temperatureDataParsed['consolidated_weather'][0]['the_temp'].round();
    });

  }

  Future<void> getLocationData() async {
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$sehir&appid=8cbc8e33e57f4e5a0787c8ae2205ecb6'));
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]['woeid'];
  }

  void getDataFromAPI() async {
    await getLocationData();
    getLocationTemperature();
  }

  @override
  void initState() {
    getDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/c.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: sicaklik == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await getLocationData();
                  //     // ignore: avoid_print
                  //     print('locationData: $locationData');
                  //     // ignore: avoid_print
                  //     print(locationData.body);
                  //     // ignore: avoid_print
                  //     print(locationData.body.runtimeType);

                  //   },
                  //   child: Text('getLocationData'),
                  // ),
                  Text(
                    '$sicaklik° C',
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        sehir,
                        style: TextStyle(fontSize: 30),
                      ),
                      IconButton(
                          onPressed: () async{
                            sehir = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));
                                    getDataFromAPI();
                                    setState(() {
                                      sehir=sehir;
                                    });
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
