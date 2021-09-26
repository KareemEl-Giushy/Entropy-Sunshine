import 'dart:convert';
import 'package:http/http.dart';

class RequestNASAPower {
  String community = 're';
  String format = 'json';
  String header = 'false';
  final urlDaily = Uri.parse('https://power.larc.nasa.gov/api/temporal/daily/point');
  final urlMonthly = Uri.parse('https://power.larc.nasa.gov/api/temporal/monthly/point');

  // Future<List<charts.Series<String, num>>> getData(String temporal, Map<String, Map> params) async {
  Future<List> getData(
      {
        required String temporal,
        required double latitude,
        required double longitude,
        required String params,
        required int start,
        required int end
      }) async {

    List data = [];
    Map parameters = {};

    switch (temporal) {
      case "climatology": {
        Uri url = Uri.https(
          'power.larc.nasa.gov',
          '/api/temporal/climatology/point',
          {
            'start': start.toString(),
            'end': end.toString(),
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
            'community': community,
            'parameters': params,
            'format': format,
            'header': header
          }
        );
        Response rawData = await get(url);
        parameters = jsonDecode(rawData.body)['properties']['parameter'];
      } break;
    }
    for (int i = 0; i < parameters.keys.length - 1; i++) {
      String key = parameters.keys.toList()[i];
      parameters[key].removeWhere((key, value) => key == "ANN");
      List<String> subKeys = parameters[key].keys.toList();
      print('$key: ${subKeys.map((e) => parameters[key][e])}');
      List<Point> points = subKeys.map((e) => Point(
          name: e,
          // value: parameters[key][e]
          value: parameters[key][e] == -999 ? 0 : parameters[key][e]
      )).toList();
      print(points);
    }
    return data;
  }
}

class Point {
  String name;
  double value;
  Point({required this.name, required this.value});
}
