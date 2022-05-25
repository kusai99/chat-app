import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hcfd/model/login_info.dart';
import 'home.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../custom_widgets/def_button.dart';
import 'dart:convert' show json, base64, ascii;

import '../styles/colors.dart';
import 'signup.dart';
import 'package:hcfd/main.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isApiCallProcess = false;
  bool hidePassword = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ProgressHUD(
          key: UniqueKey(),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: Form(key: globalFormKey, child: _loginUI(context)),
        ));
  }

  Widget _loginUI(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: h * 0.35,
            decoration: new BoxDecoration(
              color: clrRed,
              boxShadow: [new BoxShadow(blurRadius: 5.0)],
              borderRadius: new BorderRadius.vertical(
                  bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width, 80.0)),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0, 0, h * 0.06),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 30,
                      color: clrYellow,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, h * 0.04, 0, 0),
            child: Column(
              children: [
                Container(
                  width: w * 0.9,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: w * 0.01,
                    ),
                    child: TextField(
                      controller: _usernameController,
                      // focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Username",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Container(
                  width: w * 0.9,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: w * 0.01,
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: hidePassword ? true : false,
                      // focusNode: _focusNode,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        hintText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05, top: h * 0.02),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Forgot password?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('forgot password');
                                  })
                          ]),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.03),
                FormHelper.submitButton('Login', () async {
                  List<dynamic> response = await attemptLogIn(
                      _usernameController.text, _passwordController.text);
                  if (response[0] != '') {
                    storage.write(key: "jwt", value: response[0]);
                    print("JWT: ${response[0]}");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Homepage(response[1])));
                  } else {
                    displayDialog(context, "Wrong credentials",
                        "No account was found matching that username and password");
                  }
                },
                    btnColor: clrYellowButton,
                    txtColor: Colors.black,
                    borderRadius: 10,
                    borderColor: clrYellowButton,
                    width: w * 0.6)
              ],
            ),
          ),
          SizedBox(height: h * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text("Don't have an account?"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Signup(),
                      ),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 15,
                        color: clrRed,
                        fontWeight: FontWeight.w900),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<List<dynamic>> attemptLogIn(String username, String password) async {
    print(username);
    var res = await http.post(Uri.parse("$SERVER_IP/login"),
        body: {"name": username, "pw": password});

    print("response ${res.body}");

    print(res.statusCode);
    if (res.body == null) return [''];
    Map<String, dynamic> map = json.decode(res.body);
    String token = map['token'];
    int id = map["id"];
    print(token + " " + id.toString());
    if (res.statusCode == 200) return [token, id];
    return [''];
  }
}
