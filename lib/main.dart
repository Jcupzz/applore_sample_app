import 'package:applore_sample_app/AuthenticationService.dart';
import 'package:applore_sample_app/Pages/CreateProduct.dart';
import 'package:applore_sample_app/Pages/Login.dart';
import 'package:applore_sample_app/Pages/Register.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pages/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            headline2: TextStyle(fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            headline3: TextStyle(fontSize: 46, fontWeight: FontWeight.w400),
            headline4: TextStyle(fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headline5: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
            headline6: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyText2: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            overline: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ),
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/Login': (context) => Login(),
          '/Register': (context) => Register(),
          '/Home': (context) => Home(),
          '/CreateProduct': (context) => CreateProduct(),
        },
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print(firebaseUser);
    if (firebaseUser == null) {
      return Register();
    } else {
      return Home();
    }
  }
}
