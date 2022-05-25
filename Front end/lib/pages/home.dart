import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:hcfd/main.dart';
import 'package:hcfd/pages/chat.dart';
import 'package:hcfd/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'profile.dart';

import 'package:flutter/scheduler.dart';

class Homepage extends StatefulWidget {
  Homepage(this.id);

  // factory Homepage.fromBase64(String jwt) => Homepage(
  //     // jwt,
  //     // json.decode(
  //     //     ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))),
      
  //     );

  // final String jwt;
  final int id;
  // final Map<String, dynamic> payload;
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // _Request(int id) async {
  //   print('id ${id}');
  //   var response = await http.get(Uri.parse('$SERVER_IP/profile:${id}'));
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return response.body;
  //   } else {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Secret Data Screen"),
          backgroundColor: clrRed,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: w * 0.05),
                child: GestureDetector(
                  onTap: () {
                    storage.delete(key: "jwt");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Login(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Logout',
                      ),
                      Icon(
                        Icons.logout,
                      ),
                    ],
                  ),
                )),
          ],
        ),
        body: Center(
            child:  Column(
                    children: <Widget>[
                      Text(widget.id.toString()),
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                        ProfilePage(widget.id))),
                          child: Text('Profile'))
                    ],
                  )
          ));
  }
}
