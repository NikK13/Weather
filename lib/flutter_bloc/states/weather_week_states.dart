import 'package:weather/model/weathers.dart';

abstract class WeatherWeekStates{}

class WeatherWeekUninitializedState extends WeatherWeekStates{}

class WeatherWeekFetchingState extends WeatherWeekStates{}

class WeatherWeekFetchedState extends WeatherWeekStates{
  final WeekWeather? weekWeather;
  WeatherWeekFetchedState({this.weekWeather});
}

class WeatherWeekErrorState extends WeatherWeekStates{}