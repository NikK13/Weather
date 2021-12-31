import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather/data/app.dart';

class WeatherRepository{
  Future fetchWeatherForToday(double lat, double lng) async{
    Response? res;
    final url = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=${AppData.apiKey}&units=metric";
    debugPrint(url);
    try{
      res = await Client().get(Uri.parse(url));
      if(res.statusCode != 200){
        return null;
      }
      else {
        debugPrint(res.body);
      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }
}