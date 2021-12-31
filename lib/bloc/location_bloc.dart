import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather/bloc/bloc.dart';

class LocationBloc extends BaseBloc{
  final _locationSubject = BehaviorSubject<Position?>();

  Stream<Position?> get location => _locationSubject.stream;
  Function(Position?) get updateLocation => _locationSubject.sink.add;

  LocationBloc(){
    _determinePosition();
  }

  Future _determinePosition() async {
    if(await Geolocator.isLocationServiceEnabled()){
      updateLocation(await Geolocator.getCurrentPosition());
    }
    else{
      updateLocation(null);
    }
  }

  Future checkLocation() async{
    final permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      await Geolocator.requestPermission();
    }
    else{
      if(await Geolocator.isLocationServiceEnabled()){
        updateLocation(await Geolocator.getCurrentPosition());
      }
      else{
        await Geolocator.openLocationSettings();
        updateLocation(null);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

}