import 'package:applore_sample_app/AuthenticationService.dart';
import 'package:applore_sample_app/Static/Loading.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double minSize = 400;
  bool isLandScape = false;

  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  dynamic isSuccess;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      isLandScape = true;
    } else {
      isLandScape = false;
    }
    double maxSize = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Container(
                        width: isLandScape ? minSize : maxSize,
                        child: Column(
                          children: <Widget>[
                            Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: Colors.black,
                              enabled: true,
                              loop: 1,
                              period: Duration(milliseconds: 1000),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hi there",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 70,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'LobsterTwo',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.black,
                              enabled: true,
                              loop: 1,
                              period: Duration(milliseconds: 1000),
                              highlightColor: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Welcome back",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 45,
                                      fontFamily: 'LobsterTwo',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            //Email Field

                            TextFormField(
                              validator: (val) => val.isEmpty || !(val.contains('@')) ? 'Enter a valid email address' : null,
                              onChanged: (value) {
                                setState(() => email = value);
                              },
                              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelText: "Email",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            //Password Field

                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty || val.length < 6 ? 'Enter a password greater than 6 characters' : null,
                              onChanged: (value) {
                                setState(() => password = value);
                              },
                              obscureText: true,
                              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelText: "Password",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: PhysicalModel(
                                color: Colors.transparent,
                                shadowColor: Colors.black,
                                elevation: 10,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      onPrimary: Colors.white,
                                      primary: Colors.black),
                                  onPressed: () async {
                                    print("Button presed");
                                    //
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      isSuccess =
                                          await context.read<AuthenticationService>().signIn(email: email, password: password);
                                      print(isSuccess);
                                      if (isSuccess.toString() == "Signed in") {
                                        Navigator.pushReplacementNamed(context, '/Home');
                                        BotToast.showSimpleNotification(
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                          title: "Welcome back!",
                                          backgroundColor: Colors.black,
                                        );
                                      } else {
                                        Navigator.pushReplacementNamed(context, '/Register');
                                        BotToast.showSimpleNotification(
                                          title: "Failed to sign in. Please check internet connection and try again!",
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                    }
                                    //}
                                    //   dynamic result =
                                    //   await _auth.loginWithEmailAndPassword(
                                    //       email, password);
                                    //   if (result == null) {
                                    //     setState(() {
                                    //       loading = false;
                                    //       error = 'Invalid Credentials';
                                    //       print(
                                    //           "Oops...!\nSign in failed!\nInvalid Credentials");
                                    //     });
                                    //   } else {
                                    //     print('User Signed In Successfully');
                                    //     Navigator.pushNamed(context, '/List_home');
                                    //   }
                                    // }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: Text("Sign in"),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                error,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
  }
}
