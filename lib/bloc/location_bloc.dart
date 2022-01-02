import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather/bloc/bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';

class LocationBloc extends BaseBloc{
  final _locationSubject = BehaviorSubject<Position?>();
  final WeatherBloc weatherBloc = WeatherBloc();

  Stream<Position?> get location => _locationSubject.stream;
  Function(Position?) get updateLocation => _locationSubject.sink.add;

  LocationBloc(){
    _determinePosition();
  }

  Future _determinePosition() async {
    if(await Geolocator.isLocationServiceEnabled()){
      final pos = await Geolocator.getCurrentPosition();
      updateLocation(pos);
      //weatherBloc.fetchWeather(pos.latitude, pos.longitude);
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
        final pos = await Geolocator.getCurrentPosition();
        updateLocation(pos);
        //weatherBloc.fetchWeather(pos.latitude, pos.longitude);
      }
      else{
        await Geolocator.openLocationSettings();
        updateLocation(null);
      }
    }
  }

  @override
  void dispose() {
    _locationSubject.close();
  }
}