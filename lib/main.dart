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
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
              '/Login': (context) => Login(),
              '/Register': (context) => Register(),
              '/Home': (context) => Home(),
              '/CreateProduct':(context)=>CreateProduct(),
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

    }
    else{
      return Home();
    }

    

  }
}
