import 'package:geolocator/geolocator.dart';

abstract class LocationStates{}

class LocationUninitializedState extends LocationStates{}

class LocationFetchingState extends LocationStates{}

class LocationFetchedState extends LocationStates{
  final Position? position;
  LocationFetchedState({this.position});
}

class LocationErrorState extends LocationStates{}