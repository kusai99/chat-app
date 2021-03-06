// @dart=2.9
import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/home.dart';
import './pages/profile.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = 'http://192.168.0.155:3010';
final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      // home: FutureBuilder(
      //     future: jwtOrEmpty,
      //     builder: (context, snapshot) {
      //       // if (!snapshot.hasData) return CircularProgressIndicator();
      //       if (snapshot.data != "") {
      //         var str = snapshot.data.toString();
      //         var jwt = str.split(".");

      //         if (jwt.length != 3) {
      //           return Login();
      //         } else {
      //           var payload = json.decode(
      //               ascii.decode(base64.decode(base64.normalize(jwt[1]))));
      //           print(
      //               " exp: ${(DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000))}");
      //           if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
      //               .isAfter(DateTime.now())) {
      //             return Homepage(0);
      //           } else {
      //             return Login();
      //           }
      //         }
      //       } else {

      //   }
      // }),
    );
  }
}
