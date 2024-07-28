import 'package:video_diary/Core/networking/FetchLocation.dart';

class LocationRepo {
  final FetchLocation fetchlocation;

  LocationRepo({required this.fetchlocation});

  Future<String> getLocation() async {
    return await fetchlocation.getLocation();
  }
}
