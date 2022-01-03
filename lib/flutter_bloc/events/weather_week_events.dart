abstract class WeatherWeekFetchEvent{}

class WeekFetchEvent extends WeatherWeekFetchEvent{
  final double? lat, lng;
  WeekFetchEvent({this.lat, this.lng});
}