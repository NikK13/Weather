import 'package:weather/model/weather.dart';

abstract class WeatherTodayStates{}

class WeatherTodayUninitializedState extends WeatherTodayStates{}

class WeatherTodayFetchingState extends WeatherTodayStates{}

class WeatherTodayFetchedState extends WeatherTodayStates{
  final WeatherToday? todayWeather;
  WeatherTodayFetchedState({this.todayWeather});
}

class WeatherTodayErrorState extends WeatherTodayStates{}