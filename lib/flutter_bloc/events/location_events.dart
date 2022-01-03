import 'package:geolocator/geolocator.dart';

abstract class LocationEvent{}

class LocationFetchEvent extends LocationEvent{
  final Position? position;
  LocationFetchEvent({this.position});
}