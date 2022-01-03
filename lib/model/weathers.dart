class WeekWeather{
  List<SingleWeather>? weatherList;
  CityWeather? cityWeather;

  WeekWeather({
    this.weatherList,
    this.cityWeather,
  });

  static List<SingleWeather> getList(Map<String, dynamic> parsedJson){
    List<SingleWeather> data = [];
    if(parsedJson['list'] != null) {
      parsedJson['list'].forEach((element) {
        data.add(SingleWeather.fromJson(element));
      });
    }
    return data;
  }

  factory WeekWeather.fromJson(Map<String, dynamic> json){
    return WeekWeather(
      weatherList: getList(json),
      cityWeather: CityWeather.fromJson(json['city'])
    );
  }
}

class CityWeather{
  String? cityName;

  CityWeather({this.cityName});

  factory CityWeather.fromJson(Map<String, dynamic> json){
    return CityWeather(
      cityName: json['name']
    );
  }
}

class SingleWeather{
  int? dateTimestamp;
  WeatherInfo? weatherInfo;
  MainWeatherInfo? mainWeatherInfo;

  SingleWeather({
    this.dateTimestamp,
    this.weatherInfo,
    this.mainWeatherInfo
  });

  factory SingleWeather.fromJson(Map<String, dynamic> json){
    return SingleWeather(
      dateTimestamp: json['dt'] as int,
      mainWeatherInfo: MainWeatherInfo.fromJson(json['main']),
      weatherInfo: WeatherInfo.fromJson(json['weather'][0])
    );
  }
}

class MainWeatherInfo {
  final double? temp;

  MainWeatherInfo({this.temp});

  factory MainWeatherInfo.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'];
    return MainWeatherInfo(temp: temp);
  }
}

class WeatherInfo {
  final String? description;
  final String? main;
  final String? icon;

  WeatherInfo({this.description, this.icon, this.main});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    final main = json['main'];
    return WeatherInfo(description: description, icon: icon, main: main);
  }
}