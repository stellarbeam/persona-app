import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/theme_bloc/theme_bloc.dart';
import 'screens/authentication_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc();
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      _authBloc.add(FirebaseInitialized());
      print("Firebase initialized.");
    } catch (e) {
      print('Error $e}');
      // _authBloc.add(ConnectionFailed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _authBloc,
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Persona',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.cyanAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cursorColor: Colors.white60,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthenticationPage(),
      ),
    );
  }
}
