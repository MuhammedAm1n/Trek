import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class FetchLocation {
  Future<String> getLocation() async {
    //get permisson from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10));

    //convert the location to list of placemark
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //extract the city name from the first placemark

    String? city =
        "${placemarks[0].administrativeArea!.replaceAll(RegExp(r'\bGovernorate\b', caseSensitive: false), '').trim()}, ${placemarks[0].subAdministrativeArea} ";

    return city;
  }
}
