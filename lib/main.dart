import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'screens/sign_in_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initializeFlutterFire() async {
    try {
      // TODO: Implement flutterfire bloc
      await Firebase.initializeApp();
      //* SUCCESS: Connected to server
      // flutterfireBloc.add(ServerConnected());
    } catch (e) {
      //! ERROR: Could not connect to server
      // flutterfireBloc.add(ServerError());
    }
  }

  @override
  void initState() {
    initializeFlutterFire();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Persona',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.pinkAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
          child: SignInScreen(),
        ),
        routes: {
          SignInScreen.routeName: (context) => BlocProvider.value(
                value: BlocProvider.of<AuthBloc>(context),
                child: SignInScreen(),
              ),
        },
      ),
    );
  }
}
