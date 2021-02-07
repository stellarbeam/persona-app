import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

import 'phone_input_screen.dart';
import 'loading_screen.dart';
import 'otp_input_screen.dart';

class AuthenticationPage extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  // ignore: close_sinks
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return LoadingScreen();
          } else if (state is UserUnauthorized) {
            return PhoneInputScreen(_authBloc);
          } else if (state is AuthCodeSent) {
            return OtpInputScreen(_authBloc, state.phoneNumber);
          } else if (state is UserAuthorized) {
            return Container(
              child: Center(
                child: Text("Signed in"),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
