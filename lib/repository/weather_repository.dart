import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather/data/app.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/model/weathers.dart';

class WeatherRepository{
  Future<WeatherToday?> fetchWeatherForToday(double lat, double lng) async{
    Response? res;
    final url = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=${AppData.apiKey}&units=metric";
    try{
      res = await Client().get(Uri.parse(url));
      if(res.statusCode == 200){
        final weather = WeatherToday.fromJson(jsonDecode(res.body));
        //debugPrint("${weather.temperatureInfo!.temperature}");
        return weather;
      }
      else {
        return null;
      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }

  Future<WeekWeather?> fetchWeatherForWeek(double lat, double lng) async{
    Response? res;
    final url = "http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&appid=${AppData.apiKey}&units=metric";
    try{
      res = await Client().get(Uri.parse(url));
      //debugPrint(res.body);
      if(res.statusCode == 200){
        final weather = WeekWeather.fromJson(jsonDecode(res.body));
        return weather;
      }
      else {
        return null;
      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }
}