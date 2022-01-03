import 'package:rxdart/rxdart.dart';
import 'package:weather/bloc/bloc.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/model/weathers.dart';
import 'package:weather/repository/weather_repository.dart';

class WeatherBloc extends BaseBloc{
  final weatherRepository = WeatherRepository();

  final _weatherTodaySubject = BehaviorSubject<WeatherToday?>();
  final _weatherListSubject = BehaviorSubject<WeekWeather?>();

  Stream<WeatherToday?> get weatherTodayStream => _weatherTodaySubject.stream;
  Function(WeatherToday?) get fetchTodayWeather => _weatherTodaySubject.sink.add;

  Stream<WeekWeather?> get weatherListStream => _weatherListSubject.stream;
  Function(WeekWeather?) get fetchListWeather => _weatherListSubject.sink.add;

  Future fetchWeather([double lat = 0.0, double lng = 0.0]) async{
    fetchTodayWeather(await weatherRepository.fetchWeatherForToday(lat, lng));
  }

  Future fetchListOfWeather([double lat = 0.0, double lng = 0.0]) async{
    fetchListWeather(await weatherRepository.fetchWeatherForWeek(lat, lng));
  }

  @override
  void dispose() {
    _weatherTodaySubject.close();
    _weatherListSubject.close();
  }

}