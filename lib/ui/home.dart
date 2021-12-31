import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/fragment/today_fragment.dart';
import 'package:weather/fragment/week_fragment.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
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
                      TodayWeatherFragment(),
                      const WeekWeatherFragment(),
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
    );
  }
}