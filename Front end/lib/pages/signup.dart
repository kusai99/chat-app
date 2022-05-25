import 'package:flutter/material.dart';
import '../custom_widgets/def_button.dart';
import '../styles/colors.dart';
import 'package:hcfd/main.dart';
import './login.dart';
import 'package:flutter/gestures.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => SignupState();
}

class SignupState extends State<Signup> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool isApiCallProcess = false;
  bool hidePassword = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ProgressHUD(
          key: UniqueKey(),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: Form(key: globalFormKey, child: _signupUI(context)),
        ));
  }

  Widget _signupUI(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  'REGISTER',
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
                SizedBox(
                  height: h * 0.03,
                ),
                Container(
                  width: w * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.01),
                    child: TextField(
                      controller: _emailController,
                      // focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Email Address",
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
                SizedBox(height: h * 0.04),
                FormHelper.submitButton('Register', () async {
                  if (_usernameController.text.length < 4)
                    displayDialog(context, 'Invalid Username',
                        'Username should be at least 4 characters.');
                  else if (_passwordController.text.length < 4)
                    displayDialog(context, "Invalid Password",
                        "Password should be at least 4 characters long");
                  else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_emailController.text)) {
                    displayDialog(context, "Invalid email",
                        "The email you have entered is not valid");
                  } else {
                    var res = await attemptSignUp(_usernameController.text,
                        _passwordController.text, _emailController.text);
                    print(res);
                    if (res == 201 || res == 200) {
                      displayDialog(
                          context, 'Success', 'The user has been created');
                      Navigator.pushReplacementNamed(context, '/');
                    } else if (res == 409)
                      displayDialog(
                          context,
                          "That username is already registered",
                          "Please try to sign up using another username or log in if you already have an account.");
                    else {
                      displayDialog(context, "Error", res.toString());
                    }
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
                child: Text("Already have an account?"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text(
                    'Login',
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

  Future<Object> attemptSignUp(String username, String password, email) async {
    print(username);
    var res = await http.post(Uri.parse('$SERVER_IP/signup'),
        body: {"name": username, "pw": password, "email": email}
        
        );
    if (res.body.contains('A user with that username already exists')) {
      return 409;
    }
    return res.statusCode;
  }
}
