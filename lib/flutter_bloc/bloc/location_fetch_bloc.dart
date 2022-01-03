import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/flutter_bloc/events/location_events.dart';
import 'package:weather/flutter_bloc/states/location_states.dart';

class LocationFetchBloc extends Bloc<LocationEvent, LocationStates>{
  LocationFetchBloc(LocationStates initialState) : super(initialState);

  @override
  void onTransition(Transition<LocationEvent, LocationStates> transition) {
    super.onTransition(transition);
    //debugPrint("$transition");
  }

  @override
  Stream<LocationStates> mapEventToState(LocationEvent event) async* {
    yield LocationFetchingState();
    Position? position;
    try {
      if (event is LocationFetchEvent) {
        position = await checkLocation();
      }
      if (position == null) {
        yield LocationErrorState();
      } else {
        yield LocationFetchedState(position: position);
      }
    } catch (_) {
      yield LocationErrorState();
    }
  }

  Future<Position?> checkLocation() async{
    final permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      await Geolocator.requestPermission();
    }
    else{
      if(await Geolocator.isLocationServiceEnabled()){
        final pos = await Geolocator.getCurrentPosition();
        return pos;
      }
      else{
        await Geolocator.openLocationSettings();
        return null;
      }
    }
  }
}