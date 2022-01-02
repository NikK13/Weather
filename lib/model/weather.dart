class WeatherToday{
  String? city;
  int? visibility;
  SystemInfo? systemInfo;
  WindInfo? windInfo;
  WeatherInfo? weatherInfo;
  TemperatureInfo? temperatureInfo;
  CloudsInfo? cloudsInfo;

  WeatherToday({
    this.city,
    this.systemInfo,
    this.temperatureInfo,
    this.weatherInfo,
    this.windInfo,
    this.cloudsInfo,
    this.visibility
  });

  factory WeatherToday.fromJson(Map<String, dynamic> json){
    return WeatherToday(
      city: json['name'],
      systemInfo: SystemInfo.fromJson(json['sys']),
      temperatureInfo: TemperatureInfo.fromJson(json['main']),
      weatherInfo: WeatherInfo.fromJson(json['weather'][0]),
      windInfo: WindInfo.fromJson(json['wind']),
      cloudsInfo: CloudsInfo.fromJson(json['clouds']),
      visibility: json['visibility']
    );
  }
}

class CloudsInfo {
  final int? all;

  CloudsInfo({this.all});

  factory CloudsInfo.fromJson(Map<String, dynamic> json) {
    final all = json['all'];
    return CloudsInfo(all: all);
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

class SystemInfo {
  final String? country;

  SystemInfo({this.country});

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    final country = json['country'];
    return SystemInfo(country: country);
  }
}

class WindInfo {
  final double? speed;

  WindInfo({this.speed});

  factory WindInfo.fromJson(Map<String, dynamic> json) {
    final speed = json['speed'];
    return WindInfo(speed: speed);
  }
}

class TemperatureInfo {
  final double? temperature;
  final int? humidity;
  final int? seaLevel;
  final int? pressure;

  TemperatureInfo({this.temperature, this.humidity, this.seaLevel, this.pressure});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    final humidity = json['humidity'];
    final seaLevel = json['sea_level'];
    final pressure = json['pressure'];
    return TemperatureInfo(temperature: temperature, humidity: humidity, seaLevel: seaLevel, pressure: pressure);
  }
}