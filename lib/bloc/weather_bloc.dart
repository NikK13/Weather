import 'package:rxdart/rxdart.dart';
import 'package:weather/bloc/bloc.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/model/weathers.dart';
import 'package:weather/repository/weather_repository.dart';

class WeatherBloc extends BaseBloc{
  final weatherRepository = WeatherRepository();

  final _weatherTodaySubject = BehaviorSubject<WeatherToday?>();
  final _weatherListSubject = BehaviorSubject<List<SingleHourWeather>?>();

  Stream<WeatherToday?> get weatherTodayStream => _weatherTodaySubject.stream;
  Function(WeatherToday?) get fetchTodayWeather => _weatherTodaySubject.sink.add;

  Stream<List<SingleHourWeather>?> get weatherListStream => _weatherListSubject.stream;
  Function(List<SingleHourWeather>?) get fetchListWeather => _weatherListSubject.sink.add;

  Future fetchWeather([double lat = 0.0, double lng = 0.0]) async{
    fetchTodayWeather(await weatherRepository.fetchWeatherForToday(lat, lng));

  }

  Future fetchListOfWeather([double lat = 0.0, double lng = 0.0]) async{
    final list = await weatherRepository.fetchWeatherForWeek(lat, lng) ?? [];
    final List<SingleHourWeather> newList = [];
    for(int i = 0; i < list.length; i++){
      if(i == 0 || i % 3 == 0){
        newList.add(list[i]);
      }
    }
    fetchListWeather(newList);
  }

  @override
  void dispose() {
    _weatherTodaySubject.close();
    _weatherListSubject.close();
  }

}