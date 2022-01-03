import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/flutter_bloc/bloc/location_fetch_bloc.dart';
import 'package:weather/flutter_bloc/bloc/weather_today_fetch_bloc.dart';
import 'package:weather/flutter_bloc/bloc/weather_week_fetch_bloc.dart';
import 'package:weather/flutter_bloc/events/location_events.dart';
import 'package:weather/flutter_bloc/states/location_states.dart';
import 'package:weather/flutter_bloc/states/weather_today_states.dart';
import 'package:weather/flutter_bloc/states/weather_week_states.dart';
import 'package:weather/fragment/today_fragment.dart';
import 'package:weather/fragment/week_fragment.dart';
import 'package:weather/repository/weather_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weatherRepository = WeatherRepository();

  int _currentIndex = 0;

  late LocationFetchBloc locationFetchBloc;
  late WeatherTodayFetchBloc weatherTodayFetchBloc;
  late WeatherWeekFetchBloc weatherWeekFetchBloc;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white
    ));

    locationFetchBloc = LocationFetchBloc(LocationUninitializedState());
    weatherTodayFetchBloc = WeatherTodayFetchBloc(
      WeatherTodayUninitializedState(),
      weatherRepository: weatherRepository
    );
    weatherWeekFetchBloc = WeatherWeekFetchBloc(
      WeatherWeekUninitializedState(),
      weatherRepository: weatherRepository
    );
    locationFetchBloc.add(LocationFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => locationFetchBloc),
          BlocProvider(create: (context) => weatherTodayFetchBloc),
          BlocProvider(create: (context) => weatherWeekFetchBloc),
        ],
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                    bottom: 0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        TodayWeatherFragment(
                          locationFetchBloc: locationFetchBloc,
                          weatherFetchBloc: weatherTodayFetchBloc,
                        ),
                        WeekWeatherFragment(
                          locationFetchBloc: locationFetchBloc,
                          weatherFetchBloc: weatherWeekFetchBloc,
                        ),
                      ],
                    ),
                  )
                )
              ),
              CupertinoTabBar(
                backgroundColor: Colors.white,
                currentIndex: _currentIndex,
                onTap: (index){
                  setState(() => _currentIndex = index);
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.wb_sunny_outlined), label: 'Today'),
                  BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy_outlined), label: 'Forecast')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}