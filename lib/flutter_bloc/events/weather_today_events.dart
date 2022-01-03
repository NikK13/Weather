abstract class WeatherTodayFetchEvent{}

class TodayFetchEvent extends WeatherTodayFetchEvent{
  final double? lat, lng;
  TodayFetchEvent({this.lat, this.lng});
}