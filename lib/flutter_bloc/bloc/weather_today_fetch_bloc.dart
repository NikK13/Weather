import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/flutter_bloc/events/weather_today_events.dart';
import 'package:weather/flutter_bloc/states/weather_today_states.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/repository/weather_repository.dart';

class WeatherTodayFetchBloc extends Bloc<WeatherTodayFetchEvent, WeatherTodayStates>{
  final WeatherRepository? weatherRepository;

  WeatherTodayFetchBloc(WeatherTodayStates initialState, {this.weatherRepository}) : super(initialState);

  @override
  void onTransition(Transition<WeatherTodayFetchEvent, WeatherTodayStates> transition) {
    super.onTransition(transition);
    //debugPrint("$transition");
  }

  @override
  Stream<WeatherTodayStates> mapEventToState(WeatherTodayFetchEvent event) async* {
    yield WeatherTodayFetchingState();
    if (event is TodayFetchEvent) {
      WeatherToday? weatherToday;
      try{
        weatherToday = await weatherRepository!.fetchWeatherForToday(
          event.lat!,
          event.lng!
        );
        if (weatherToday == null) {
          yield WeatherTodayErrorState();
        }
        else {
          yield WeatherTodayFetchedState(todayWeather: weatherToday);
        }
      }
      catch (e) {
        yield WeatherTodayErrorState();
      }
    }
  }
}