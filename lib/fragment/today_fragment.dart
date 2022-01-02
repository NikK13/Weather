import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:weather/bloc/location_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/model/weather.dart';

class TodayWeatherFragment extends StatelessWidget {
  final LocationBloc? locationBloc;
  final WeatherBloc? weatherBloc;

  const TodayWeatherFragment({Key? key, this.locationBloc, this.weatherBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: locationBloc!.location,
        builder: (context, AsyncSnapshot<Position?> snapshot) {
          //debugPrint("Connect: ${snapshot.connectionState},${snapshot.data}");
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return TodayWeatherView(
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

class TodayWeatherView extends StatefulWidget {
  final double? lat, lng;
  final WeatherBloc? weatherBloc;

  const TodayWeatherView({Key? key, this.lat, this.lng, this.weatherBloc}) : super(key: key);

  @override
  State<TodayWeatherView> createState() => _TodayWeatherViewState();
}

class _TodayWeatherViewState extends State<TodayWeatherView> {

  @override
  void initState() {
    widget.weatherBloc!.fetchWeather(widget.lat!, widget.lng!);
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
      body: StreamBuilder(
        stream: widget.weatherBloc!.weatherTodayStream,
        builder: (context, AsyncSnapshot<WeatherToday?> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return buildTodayView(snapshot.data!);
            }
            else{
              return const Center(child: Text("Empty data"));
            }
          }
          return const Center(child: CircularProgressIndicator());
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


