import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/flutter_bloc/events/weather_week_events.dart';
import 'package:weather/flutter_bloc/states/weather_week_states.dart';
import 'package:weather/model/weathers.dart';
import 'package:weather/repository/weather_repository.dart';

class WeatherWeekFetchBloc extends Bloc<WeatherWeekFetchEvent, WeatherWeekStates>{
  final WeatherRepository? weatherRepository;

  WeatherWeekFetchBloc(WeatherWeekStates initialState, {this.weatherRepository}) : super(initialState);

  @override
  void onTransition(Transition<WeatherWeekFetchEvent, WeatherWeekStates> transition) {
    super.onTransition(transition);
    //debugPrint("$transition");
  }

  @override
  Stream<WeatherWeekStates> mapEventToState(WeatherWeekFetchEvent event) async* {
    yield WeatherWeekFetchingState();
    if (event is WeekFetchEvent) {
      WeekWeather? weekWeather;
      try{
        weekWeather = await weatherRepository!.fetchWeatherForWeek(
          event.lat!,
          event.lng!
        );
        if (weekWeather == null) {
          yield WeatherWeekErrorState();
        } else {
          yield WeatherWeekFetchedState(weekWeather: weekWeather);
        }
      }
      catch (e) {
        yield WeatherWeekErrorState();
      }
    }
  }
}