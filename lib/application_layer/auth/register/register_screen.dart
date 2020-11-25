import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/components/get_user_id.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/shared/constants.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  final Function toogleView;
  RegisterScreen({this.toogleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                "Great Tracker",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              // actions: <Widget>[
              //   FlatButton.icon(
              //     icon: Icon(Icons.person),
              //     label: Text("Sign in"),
              //     onPressed: () => widget.toogleView(),
              //   ),
              // ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: height / 3.5,
                          child: Image(
                            image: AssetImage("assets/register_background.png"),
                          )),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: kTextFormFieldStyle,
                          decoration: kLoginScreenTextInputDecoration.copyWith(
                              hintText: "Name"),
                          validator: (val) =>
                              val.isEmpty ? "Name cannot be empty" : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: kTextFormFieldStyle,
                          decoration: kLoginScreenTextInputDecoration.copyWith(
                              hintText: "Email"),
                          validator: (val) {
                              if(val.isEmpty) {return "Empty";}
                              else if (! EmailValidator.validate(val)) {
                                return "Email is not valid";
                              }
                              },
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _pass,
                          textAlign: TextAlign.center,
                          style: kTextFormFieldStyle,
                          decoration: kLoginScreenTextInputDecoration.copyWith(
                              hintText: "Password"),
                          validator: (val) => val.length < 6
                              ? "Enter a password 6+ chars long"
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          obscureText: true,
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _confirmPass,
                          textAlign: TextAlign.center,
                          
                          style: kTextFormFieldStyle,
                          decoration: kLoginScreenTextInputDecoration.copyWith(
                              hintText: "Password"),
                          validator: (val) {
                            if (val.isEmpty) return 'Empty';
                            if (val != _pass.text)
                              return 'Passwords do not match';
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      CupertinoButton(
                        child: Container(
                            width: width / 3,
                            height: height / 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.indigoAccent),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ))),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password,name);

                            if (result == null) {
                              setState(() {
                                error = "Please supply a valid email";
                                loading = false;
                              });
                            }
                            getUserID();
                          }
                        },
                      ),
                      // RaisedButton(
                      //   color: Colors.indigoAccent,
                      //   child: Text(
                      //     "Register",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   onPressed: () async {
                      //     if (_formKey.currentState.validate()) {
                      //       setState(() => loading = true);
                      //       dynamic result = await _auth
                      //           .registerWithEmailAndPassword(email, password);
                      //       if (result == null) {
                      //         setState(() {
                      //           error = "please supply a valid email";
                      //           loading = false;
                      //         });
                      //       }
                      //     }
                      //   },
                      // ),

                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                      GestureDetector(
                          onTap: () => widget.toogleView(),
                          child: Text("Do you have an account ? Sign in"))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
