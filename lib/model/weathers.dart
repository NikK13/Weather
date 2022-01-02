class SingleHourWeather{
  int? dateTimestamp;
  double? temperature;
  WeatherHourlyInfo? weatherHourlyInfo;

  SingleHourWeather({
    this.dateTimestamp,
    this.temperature,
    this.weatherHourlyInfo,
  });

  factory SingleHourWeather.fromJson(Map<String, dynamic> json){
    return SingleHourWeather(
      dateTimestamp: json['dt'] as int,
      temperature: json['temp'] as double?,
      weatherHourlyInfo: WeatherHourlyInfo.fromJson(json['weather'][0])
    );
  }
}

class WeatherHourlyInfo {
  final String? description;
  final String? main;
  final String? icon;

  WeatherHourlyInfo({this.description, this.icon, this.main});

  factory WeatherHourlyInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    final main = json['main'];
    return WeatherHourlyInfo(description: description, icon: icon, main: main);
  }
}