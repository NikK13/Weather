import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/flutter_bloc/bloc/location_fetch_bloc.dart';
import 'package:weather/flutter_bloc/bloc/weather_week_fetch_bloc.dart';
import 'package:weather/flutter_bloc/events/location_events.dart';
import 'package:weather/flutter_bloc/events/weather_week_events.dart';
import 'package:weather/flutter_bloc/states/location_states.dart';
import 'package:weather/flutter_bloc/states/weather_week_states.dart';
import 'package:weather/model/weathers.dart';

class WeekWeatherFragment extends StatefulWidget {
  final LocationFetchBloc? locationFetchBloc;
  final WeatherWeekFetchBloc? weatherFetchBloc;

  const WeekWeatherFragment({
    Key? key,
    this.locationFetchBloc,
    this.weatherFetchBloc
  }) : super(key: key);

  @override
  State<WeekWeatherFragment> createState() => _WeekWeatherFragmentState();
}

class _WeekWeatherFragmentState extends State<WeekWeatherFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder(
        bloc: widget.locationFetchBloc,
        builder: (context, state){
          if(state is LocationFetchedState){
            final pos = state.position;
            return WeekWeatherView(
              lat: pos!.latitude,
              lng: pos.longitude,
              weatherBloc: widget.weatherFetchBloc,
            );
          }
          else if(state is LocationErrorState){
            return locationDisabled();
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Widget locationDisabled(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Oops, permission is denied or location service is disabled..",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          child: const Text("Check location"),
          onPressed: (){
            widget.locationFetchBloc!.add(LocationFetchEvent());
          },
        ),
      ],
    );
  }
}

class WeekWeatherView extends StatefulWidget {
  final double? lat, lng;
  final WeatherWeekFetchBloc? weatherBloc;

  const WeekWeatherView({Key? key, this.lat, this.lng, this.weatherBloc}) : super(key: key);

  @override
  State<WeekWeatherView> createState() => _WeekWeatherViewState();
}

class _WeekWeatherViewState extends State<WeekWeatherView> {
  @override
  void initState() {
    widget.weatherBloc!.add(
      WeekFetchEvent(
        lat: widget.lat,
        lng: widget.lng,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.weatherBloc,
      builder: (context, state){
        if(state is WeatherWeekFetchedState){
          return Scaffold(
            appBar: CupertinoNavigationBar(
              middle: Text("${state.weekWeather!.cityWeather!.cityName}"),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: buildForecastView(state.weekWeather!.weatherList!),
            ),
          );
        }
        else if(state is WeatherWeekErrorState){
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text("No data")),
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildForecastView(List<SingleWeather> weatherList){
    return OrientationBuilder(
      builder: (context, orientation){
        if(orientation == Orientation.portrait){
          return buildForecastViewPortrait(weatherList);
        }
        return buildForecastViewPortrait(weatherList);
      },
    );
  }

  DateTime getParsedDate(DateTime date){
    return DateTime(date.year, date.month, date.day);
  }

  Widget buildForecastViewPortrait(List<SingleWeather> weatherList){
    return ListView.builder(
      itemCount: weatherList.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        bool showTime = false;
        final weather = weatherList[index];
        if(index == 0) showTime = true;
        if(index > 0){
          final weatherBefore = weatherList[index - 1];
          if(!getParsedDate(DateTime.fromMillisecondsSinceEpoch(weather.dateTimestamp! * 1000)).isAtSameMomentAs(
              getParsedDate(DateTime.fromMillisecondsSinceEpoch(weatherBefore.dateTimestamp! * 1000)))){
            showTime = true;
          }
        }
        return portraitItem(weather, showTime, index == 0);
      },
    );
  }

  String formattedDate(DateTime date){
    return "${date.day}/${date.month}/${date.year}";
  }

  String formattedTime(DateTime date){
    final min = date.minute > 9 ? "${date.minute}" : "0${date.minute}";
    return "${date.hour}:$min";
  }

  Widget portraitItem(SingleWeather weather, bool showDate, bool isToday){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(showDate)
        Text(isToday ?
          "Today" :
          DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(weather.dateTimestamp! * 1000)),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        Row(
          children: [
            Image.network(
              "http://openweathermap.org/img/w/" + weather.weatherInfo!.icon! + ".png",
              width: 100, height: 100, fit: BoxFit.fill,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedTime(DateTime.fromMillisecondsSinceEpoch(weather.dateTimestamp! * 1000)),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.weatherInfo!.main!,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              )
            ),
            const SizedBox(width: 8),
            Text(
              "${weather.mainWeatherInfo!.temp!.round()}°",
              style: const TextStyle(
                fontSize: 36,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}