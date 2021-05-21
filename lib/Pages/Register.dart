import 'package:applore_sample_app/AuthenticationService.dart';
import 'package:applore_sample_app/Static/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double minSize = 400;
  bool isLandScape = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
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
            backgroundColor: Colors.purple[900],
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Welcome to",
                                style: TextStyle(
                                    color: Colors.deepOrange[200],
                                    fontSize: 45,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'LobsterTwo',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Shoppy.",
                                style: TextStyle(
                                    color: Colors.deepOrange[300],
                                    fontSize: 70,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'LobsterTwo',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),

                            //Email Field

                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty || !(val.contains('@'))
                                      ? 'Enter a valid email address'
                                      : null,
                              onChanged: (value) {
                                setState(() => email = value);
                              },
                              style: TextStyle(color: Colors.purple[200]),
                              cursorColor: Colors.deepOrange,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.deepOrange[200],
                                ),
                                labelText: "Email",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.purple[200]),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.deepOrange[200]),
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
                              validator: (val) => val.isEmpty || val.length < 6
                                  ? 'Enter a password greater than 6 characters'
                                  : null,
                              onChanged: (value) {
                                setState(() => password = value);
                              },
                              obscureText: true,
                              style: TextStyle(color: Colors.purple[200]),
                              cursorColor: Colors.deepOrange,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.deepOrange[200],
                                ),
                                labelText: "Password",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.purple[200]),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.deepOrange[200]),
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
                              width: double.infinity,
                              child: PhysicalModel(
                                color: Colors.transparent,
                                shadowColor: Colors.deepPurple[900],
                                elevation: 10,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic isSuccess = await context
                                          .read<AuthenticationService>()
                                          .signUp(
                                              email: email, password: password);
                                      if (isSuccess.toString() == "Signed up") {
                                        Navigator.pushReplacementNamed(
                                            context, '/Home');
                                        BotToast.showSimpleNotification(
                                          title: " Welcome! ",
                                          backgroundColor: Colors.orangeAccent,
                                        );
                                      } else {
                                        Navigator.pushReplacementNamed(
                                            context, '/Register');
                                        BotToast.showSimpleNotification(
                                          title:
                                              "Failed to register. Please check internet connection and try again!",
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                    }
                                    // if (_formkey.currentState.validate()) {
                                    //   setState(() {
                                    //     loading = true;
                                    //   });
                                    //   dynamic result =
                                    //   await _auth.registerWithEmailAndPassword(
                                    //       email, password);
                                    //   if (result == null) {
                                    //     setState(() {
                                    //       print("Error user not registered");
                                    //       loading = false;
                                    //     });
                                    //   } else {
                                    //     print('User Signed In Successfully');
                                    //     Navigator.pushReplacementNamed(
                                    //         context, '/List_home');
                                    //  }
                                    // }
                                  },
                                  color: Colors.deepOrange[400],
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: Text("Sign up"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Login');
                                },
                                child: Text(
                                  "Already registered ? Login Here",
                                  style: TextStyle(
                                      color: Colors.deepOrange[400],
                                      fontFamily: 'Sans',
                                      fontWeight: FontWeight.w900),
                                )),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                  height: 20,
                                  color: Colors.deepOrange,
                                )),
                                Text(
                                  "OR",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                  height: 20,
                                  color: Colors.deepOrange,
                                )),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: ()async{
                                  dynamic isSuccess = await context
                                          .read<AuthenticationService>().signInWithGoogle();
                                  print(isSuccess);
                                  
                                  final firebaseUser = context.watch<User>();
                                  print("FIREBASE UID: "+firebaseUser.uid);

                                  
                                },
                                child: Row(
                                children: [

                                  SvgPicture.asset("assets/google_logo.svg",fit: BoxFit.cover,width: 24,height: 24,),
                                  SizedBox(width: 20,),
                                  Text("Sign in with Google"),
                                ],
                              
                              ),)
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
