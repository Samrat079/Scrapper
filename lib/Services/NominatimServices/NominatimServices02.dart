import 'package:latlong2/latlong.dart';
import 'package:nominatim_flutter/model/request/request.dart';
import 'package:nominatim_flutter/model/response/nominatim_response.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:rxdart/rxdart.dart';

class NominatimServices02 {
  final nominatim = NominatimFlutter.instance;

  Future<List<NominatimResponse>> searchByString(String query) =>
      nominatim.search(
        searchRequest: SearchRequest(
          limit: 10,
          query: query,
          countryCodes: ['in'],
        ),
      );

  Stream<List<NominatimResponse>> streamByString01(String query) =>
      Stream.value(query)
          .debounceTime(Duration(milliseconds: 400))
          .where((query) => query.isNotEmpty)
          .distinct()
          .asyncMap((query) => searchByString(query));

  Future<NominatimResponse> reverse(LatLng latlng) => nominatim.reverse(
    reverseRequest: ReverseRequest(lat: latlng.latitude, lon: latlng.longitude),
  );
}
