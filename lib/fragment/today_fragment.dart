import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/bloc/location_bloc.dart';

class TodayWeatherFragment extends StatefulWidget {

  TodayWeatherFragment({Key? key}) : super(key: key);

  @override
  State<TodayWeatherFragment> createState() => _TodayWeatherFragmentState();
}

class _TodayWeatherFragmentState extends State<TodayWeatherFragment> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    locationBloc = LocationBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: locationBloc.location,
        builder: (context, AsyncSnapshot<Position?> snapshot) {
          //debugPrint("Connect: ${snapshot.connectionState},${snapshot.data}");
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return TodayWeatherView(
                lat: snapshot.data!.latitude,
                lng: snapshot.data!.longitude,
              );
            }
            else{
              return locationDisabled();
            }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Widget locationDisabled(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Oops, permission is denied or location service is disabled..",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          child: const Text("Check location"),
          onPressed: () async{
            await locationBloc.checkLocation();
          },
        ),
      ],
    );
  }
}

class TodayWeatherView extends StatelessWidget {
  final double? lat, lng;

  const TodayWeatherView({Key? key, this.lat, this.lng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("$lat, $lng"));
  }
}

