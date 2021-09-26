import 'package:entropy_sunshine/services/request_nasa_power.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  RequestNASAPower request = RequestNASAPower();
  bool gotData = false;
  List data = List.empty();

  Future<void> collectData() async {
    data = await request.getData(
        temporal: 'climatology',
        latitude: 0.0,
        longitude: 0.0,
        params: 'SI_EF_TILTED_SURFACE',
        start: 2018,
        end: 2019);
    setState(() {gotData = true;});
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
            Container(
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
            Expanded(
              child: gotData ? Container() : Container(),
            )
          ]
        ),
      ),
    );
  }
}
