// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(WeatherApp());


class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double temperature = 0;
  String location = "Please select location";
  String apiKey = "6c58923892d0acae68b806de8279eb68";
  

  void search(String input) async
  {
    setLocation() async 
    { 
      try {
      double currentLat = 0;
      double currentLon = 0;
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); 
      currentLat = position.latitude; 
      currentLon = position.longitude;
      String currentLocUrl = "http://api.openweathermap.org/geo/1.0/reverse?lat=${currentLat}&lon=${currentLon}&appid=${apiKey}";
      var curLoc = await http.get(currentLocUrl);
      var parsedCurLoc = json.decode(curLoc.body);
      var cityName = parsedCurLoc[0]["name"];

      String curLocTempUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${currentLat}&lon=${currentLon}&appid=${apiKey}";
      var curLocTempRes = await http.get(curLocTempUrl);
      var parsedCurLocTempRes = json.decode(curLocTempRes.body);
      var curLocTemp = parsedCurLocTempRes["main"]["temp"] - 273;
      setState((){location = cityName; temperature = double.parse(curLocTemp.toStringAsFixed(2));});
      } catch (error) {
        setState((){location = "I don't know how could this happen!!!"; temperature = 0;});
      }
    }


    if(input=="Current")
    {
      setLocation();
      /*
      String currentLocUrl = "http://api.openweathermap.org/geo/1.0/reverse?lat=${currentLat}&lon=${currentLon}&appid=${apiKey}";
      var curLoc = await http.get(currentLocUrl);
      var parsedCurLoc = json.decode(curLoc.body);
      print(currentLocUrl);

      String curLocTempUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${currentLat}&lon=${currentLon}&appid=${apiKey}";
      var curLocTempRes = await http.get(curLocTempUrl);
      var parsedCurLocTempRes = json.decode(curLocTempRes.body);
      var curLocTemp = parsedCurLocTempRes["main"]["temp"] - 273;
      setState((){location = curLocTemp["name"]; temperature = double.parse(curLocTemp.toStringAsFixed(2));});*/
    }

    else
    {
      try{
      String locationUrl = "http://api.openweathermap.org/geo/1.0/direct?q=${input}&limit=5&appid=${apiKey}";
      var locationRes = await http.get(locationUrl);
      var parsedLocationRes = json.decode(locationRes.body)[0];

      double lat = parsedLocationRes["lat"];
      double lon = parsedLocationRes["lon"];
        String tempUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}";
        var tempRes = await http.get(tempUrl);
        var parsedTempRes = json.decode(tempRes.body);
        var temp = parsedTempRes["main"]["temp"] - 273; //api return kevin as default unit
        setState((){location = parsedLocationRes["name"]; temperature = double.parse(temp.toStringAsFixed(2));});
      } catch(error){
        setState((){location = "City does not exist"; temperature = 0;});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //don't show banner
      home: Container(
          child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              location,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 60.0, fontFamily: "ProximaNova"),
                            ),
                          ),
                          Center(
                            child: Text(
                              temperature.toString() + ' Celcius',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40.0, fontFamily: "ProximaNova"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 200,
                            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                            child: TextField(
                              onSubmitted: (String input) {
                                print(input);
                                search(input);
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),     
                        ],                
                      ),
                    ],
                  ),
                )),
    );
  }
}