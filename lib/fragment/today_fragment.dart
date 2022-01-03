import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:weather/flutter_bloc/bloc/location_fetch_bloc.dart';
import 'package:weather/flutter_bloc/bloc/weather_today_fetch_bloc.dart';
import 'package:weather/flutter_bloc/events/location_events.dart';
import 'package:weather/flutter_bloc/events/weather_today_events.dart';
import 'package:weather/flutter_bloc/states/location_states.dart';
import 'package:weather/flutter_bloc/states/weather_today_states.dart';
import 'package:weather/model/weather.dart';

class TodayWeatherFragment extends StatefulWidget {
  final LocationFetchBloc? locationFetchBloc;
  final WeatherTodayFetchBloc? weatherFetchBloc;

  const TodayWeatherFragment({
    Key? key,
    this.locationFetchBloc,
    this.weatherFetchBloc,
  }) : super(key: key);

  @override
  State<TodayWeatherFragment> createState() => _TodayWeatherFragmentState();
}

class _TodayWeatherFragmentState extends State<TodayWeatherFragment> {
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
            return TodayWeatherView(
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

class TodayWeatherView extends StatefulWidget {
  final double? lat, lng;
  final WeatherTodayFetchBloc? weatherBloc;

  const TodayWeatherView({Key? key, this.lat, this.lng, this.weatherBloc}) : super(key: key);

  @override
  State<TodayWeatherView> createState() => _TodayWeatherViewState();
}

class _TodayWeatherViewState extends State<TodayWeatherView> {
  @override
  void initState() {
    widget.weatherBloc!.add(
      TodayFetchEvent(
        lat: widget.lat,
        lng: widget.lng
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Today"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: widget.weatherBloc,
        builder: (context, state){
          if(state is WeatherTodayFetchedState){
            return buildTodayView(state.todayWeather!);
          }
          else if(state is WeatherTodayErrorState){
            return const Center(
              child: Text("Empty data")
            );
          }
          else{
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        },
      )
    );
  }

  Widget buildTodayView(WeatherToday weather){
    return OrientationBuilder(
      builder: (context, orientation){
        if(orientation == Orientation.portrait){
          return buildTodayViewPortrait(weather);
        }
        return buildTodayViewLandscape(weather);
      },
    );
  }

  Widget buildTodayViewLandscape(WeatherToday weather){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Image.network(
                  "http://openweathermap.org/img/w/" + weather.weatherInfo!.icon! + ".png",
                  width: 100, height: 100,
                  fit: BoxFit.fill,
                ),
                Text(
                  "${weather.city}, ${weather.systemInfo!.country}",
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black54
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${weather.temperatureInfo!.temperature!.round()}°C",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blueAccent
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      color: Colors.blueAccent,
                      width: 1.5, height: 28,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${weather.weatherInfo!.main}",
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.blueAccent
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        dividerColumn,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WeatherTodayInfoItem(
                  icon: CupertinoIcons.cloud_drizzle,
                  info: "${weather.cloudsInfo!.all} %",
                ),
                WeatherTodayInfoItem(
                  icon: CupertinoIcons.umbrella,
                  info: "${weather.temperatureInfo!.humidity} mm",
                ),
                WeatherTodayInfoItem(
                  icon: CupertinoIcons.sun_dust_fill,
                  info: "${weather.temperatureInfo!.pressure} hPa",
                ),
                WeatherTodayInfoItem(
                  icon: CupertinoIcons.umbrella,
                  info: "${weather.windInfo!.speed} km/h",
                ),
                WeatherTodayInfoItem(
                  icon: CupertinoIcons.sun_dust_fill,
                  info: "${weather.visibility} m",
                )
              ],
            ),
          ),
        ),
        dividerColumn,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8
            ),
            child: Center(
              child: GestureDetector(
                onTap: (){
                  Share.share("Weather at ${weather.city} is now ${weather.temperatureInfo!.temperature!.round()}°C");
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade700
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildTodayViewPortrait(WeatherToday weather){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Image.network(
                "http://openweathermap.org/img/w/" + weather.weatherInfo!.icon! + ".png",
                width: 100, height: 100,
                fit: BoxFit.fill,
              ),
              Text(
                "${weather.city}, ${weather.systemInfo!.country}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black54
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${weather.temperatureInfo!.temperature!.round()}°C",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blueAccent
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    color: Colors.blueAccent,
                    width: 1.5, height: 28,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${weather.weatherInfo!.main}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blueAccent
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        dividerRow,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeatherTodayInfoItem(
                    icon: CupertinoIcons.cloud_drizzle,
                    info: "${weather.cloudsInfo!.all} %",
                  ),
                  WeatherTodayInfoItem(
                    icon: CupertinoIcons.umbrella,
                    info: "${weather.temperatureInfo!.humidity} mm",
                  ),
                  WeatherTodayInfoItem(
                    icon: CupertinoIcons.sun_dust_fill,
                    info: "${weather.temperatureInfo!.pressure} hPa",
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeatherTodayInfoItem(
                    icon: CupertinoIcons.speedometer,
                    info: "${weather.windInfo!.speed} km/h",
                  ),
                  WeatherTodayInfoItem(
                    icon: CupertinoIcons.cloud_download,
                    info: "${weather.visibility} m",
                  )
                ],
              )
            ],
          ),
        ),
        dividerRow,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8
            ),
            child: Center(
              child: GestureDetector(
                onTap: (){
                  Share.share("Weather at ${weather.city} is now ${weather.temperatureInfo!.temperature!.round()}°C");
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade700
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget get dividerRow => Container(
    width: double.infinity,
    height: 2,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    color: Colors.black12,
  );

  Widget get dividerColumn => Container(
    width: 2,
    height: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    color: Colors.black12,
  );
}

class WeatherTodayInfoItem extends StatelessWidget {
  final IconData? icon;
  final String? info;

  const WeatherTodayInfoItem({Key? key, this.icon, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.yellow.shade700
        ),
        const SizedBox(height: 6),
        Text(
          info!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black38,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}


