import 'package:entropy_sunshine/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
  );
  runApp(
      MaterialApp(
        initialRoute: '/home',
        routes: {
          '/home': (context) => Home(),
        },
        debugShowCheckedModeBanner: false,
      )
  );
}
