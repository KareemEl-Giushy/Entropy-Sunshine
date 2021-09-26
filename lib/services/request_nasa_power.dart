import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestNASAPower {
  String community = 're';
  String format = 'json';
  String header = 'false';
  final urlDaily = Uri.parse('https://power.larc.nasa.gov/api/temporal/daily/point');
  final urlMonthly = Uri.parse('https://power.larc.nasa.gov/api/temporal/monthly/point');
  final List<Color> colors = [
    Colors.deepOrange,
    Colors.pink,
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.brown,
  ];

  // Future<List<charts.Series<String, num>>> getData(String temporal, Map<String, Map> params) async {
  Future<List<List<ChartSeries>>> getData(
      {
        required String temporal,
        required double latitude,
        required double longitude,
        required String params,
        required int start,
        required int end
      }) async {

    List<ChartSeries> exactData = [];
    List<ChartSeries> splineData = [];
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
    for (int i = 0; i < 5; i++) {

      String key = parameters.keys.toList()[i];
      parameters[key].removeWhere((key, value) => key == "ANN");
      List<String> subKeys = parameters[key].keys.toList();
      // print('$key: ${subKeys.map((e) => parameters[key][e])}');
      List<Point> points = subKeys.map((e) => Point(
          name: e,
          // value: parameters[key][e]
          value: parameters[key][e] == -999 ? 0 : parameters[key][e]
      )).toList();
      
      exactData.add(AreaSeries<Point, String>(
        dataSource: points,
        name: key,
        xValueMapper: (Point point, _) => point.name,
        yValueMapper: (Point point, _) => point.value,
        color: colors[i],
        borderColor: colors[i],
        borderWidth: 5,
        borderDrawMode: BorderDrawMode.top,
        opacity: 0.2,
      ));

      splineData.add(SplineAreaSeries<Point, String>(
        dataSource: points,
        name: key,
        xValueMapper: (Point point, _) => point.name,
        yValueMapper: (Point point, _) => point.value,
        color: colors[i],
        borderColor: colors[i],
        borderWidth: 5,
        borderDrawMode: BorderDrawMode.top,
        opacity: 0.2,
      ));
      
    }
    return [exactData, splineData];
  }
}

class Point {
  String name;
  double value;
  Point({required this.name, required this.value});
}
