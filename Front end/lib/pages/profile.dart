import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show json, base64, ascii;
import 'package:hcfd/main.dart';
import 'package:hcfd/pages/chat.dart';
import 'package:hcfd/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter/scheduler.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.id);
  final int id;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _Request(int id) async {
    // print('id ${id}');
    var response = await http.get(Uri.parse('$SERVER_IP/profile/${id}'));
    print('status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: FutureBuilder(
                future: _Request(widget.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print("Snapshot data: ${snapshot.data}");
                  print("has data: ${snapshot.hasData}");
                  return Column(
                    children: <Widget>[
                      Text('id: ${widget.id.toString()}'),
                      Text(snapshot.data,
                          style: Theme.of(context).textTheme.headline4),
                      Text(snapshot.data[{'name'}]),
                    ],
                  );
                })),
      ),
    );
  }
}
