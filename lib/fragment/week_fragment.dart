import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/model/weathers.dart';

class WeekWeatherFragment extends StatelessWidget {
  final LocationBloc? locationBloc;
  final WeatherBloc? weatherBloc;

  const WeekWeatherFragment({Key? key, this.locationBloc, this.weatherBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: locationBloc!.location,
          builder: (context, AsyncSnapshot<Position?> snapshot) {
            //debugPrint("Connect: ${snapshot.connectionState},${snapshot.data}");
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return WeekWeatherView(
                  lat: snapshot.data!.latitude,
                  lng: snapshot.data!.longitude,
                  weatherBloc: weatherBloc,
                );
              }
              else{
                return locationDisabled();
              }
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
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
          onPressed: () async{
            await locationBloc!.checkLocation();
          },
        ),
      ],
    );
  }
}

class WeekWeatherView extends StatefulWidget {
  final double? lat, lng;
  final WeatherBloc? weatherBloc;

  const WeekWeatherView({Key? key, this.lat, this.lng, this.weatherBloc}) : super(key: key);

  @override
  State<WeekWeatherView> createState() => _WeekWeatherViewState();
}

class _WeekWeatherViewState extends State<WeekWeatherView> {

  @override
  void initState() {
    widget.weatherBloc!.fetchListOfWeather(widget.lat!, widget.lng!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.weatherBloc!.weatherListStream,
      builder: (context, AsyncSnapshot<List<SingleHourWeather>?> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            return Scaffold(
              appBar: const CupertinoNavigationBar(
                middle: Text("Forecast"),
                backgroundColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: buildForecastView(snapshot.data!),
              ),
            );
          }
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text("No data")),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Widget buildForecastView(List<SingleHourWeather> weatherList){
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

  Widget buildForecastViewPortrait(List<SingleHourWeather> weatherList){
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

  Widget portraitItem(SingleHourWeather weather, bool showDate, bool isToday){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(showDate)
        Text(isToday ?
          "Today" :
          formattedDate(DateTime.fromMillisecondsSinceEpoch(weather.dateTimestamp! * 1000)),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        Row(
          children: [
            Image.network(
              "http://openweathermap.org/img/w/" + weather.weatherHourlyInfo!.icon! + ".png",
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
                    weather.weatherHourlyInfo!.main!,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              )
            ),
            const SizedBox(width: 8),
            Text(
              "${weather.temperature!.round()}°",
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