import 'package:entropy_sunshine/services/request_nasa_power.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  RequestNASAPower request = RequestNASAPower();
  bool toggleSpline = true;
  List<List<ChartSeries>> data = List.empty();
  List<ChartSeries> exactData = List.empty();
  List<ChartSeries> splineData = List.empty();
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
  );

  Future<void> collectData() async {
    data = await request.getData(
        temporal: 'climatology',
        latitude: 0.0,
        longitude: 0.0,
        params: 'SI_EF_TILTED_SURFACE',
        start: 2018,
        end: 2019);
    setState(() {
      exactData = data[0];
      splineData = data[1];
    });
  }

  @override
  void initState() {
    super.initState();
    collectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff132030),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu_rounded),
                  iconSize: 60,
                ),
                Expanded(
                  child: Container(
                    margin: new EdgeInsets.all(20),
                    child: RawMaterialButton(
                      onPressed: () {},
                      fillColor: Color(0xff7c8083),
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                'Location',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Egypt, Cairo',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {setState(() {toggleSpline = !toggleSpline;});},
                  icon: Icon(Icons.refresh_rounded, color: Colors.white),
                  iconSize: 30,
                ),
                Text(
                  'Title is Here',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ),
                SizedBox(width: 40)
              ]
            ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: toggleSpline ? splineData : exactData,
                tooltipBehavior: _tooltipBehavior,
                zoomPanBehavior: _zoomPanBehavior,
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: TextStyle(
                    color: Color(0xff7c8083),
                    fontSize: 15,
                    fontFamily: 'Georgia'
                  )
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
