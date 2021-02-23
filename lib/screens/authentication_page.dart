import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/theme_bloc/theme_bloc.dart';

import 'loading_screen.dart';
import 'phone_input_screen.dart';
import 'otp_input_screen.dart';
import 'profile_completion_screen.dart';
import 'onboarding_screen.dart';

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
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileCompleted) {
            Navigator.of(context)
                .pushReplacementNamed(OnboardingScreen.routeName);
          }
        },
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
          } else if (state is ProfileCompletion) {
            return ProfileCompletionScreen(_authBloc);
          } else if (state is NoConnectivity) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: state.themeData.backgroundGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No connectivity!',
                      style: TextStyle(
                        color: state.themeData.helpText,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // Plain gradient
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: state.themeData.backgroundGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
