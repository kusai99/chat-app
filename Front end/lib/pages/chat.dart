
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../main.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

late Socket socket;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    try {
      // Configure socket transports must be sepecified
      socket = io(SERVER_IP, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      socket.on('connect',
          (_) => print('connected to server, socket id: ${socket.id}'));
      socket.on('disconnect', (_) => print('disconnect'));
      print(socket.connected);

      socket.on('newMsg', (_) => print('Message received'));
    } catch (err) {
      print(err.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(),
              FormHelper.submitButton("send", () => send()),
              FormHelper.submitButton("join", () => join())
            ],
          ),
        ),
      ),
    );
  }
}

void send() {
  socket.emit('sendMsg');
}

void join() {
  socket.emit('joinRoom');
  print('joining room');
}
