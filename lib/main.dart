import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persona/screens/home_screen.dart';
import 'package:persona/screens/onboarding_screen.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/lang_bloc/lang_bloc.dart';
import 'blocs/theme_bloc/theme_bloc.dart';

import 'screens/authentication_page.dart';
import 'localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc _authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();

    // Notify auth bloc that firebase has been initialized
    _authBloc.add(FirebaseInitialized());
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
        BlocProvider(
          create: (context) => LangBloc(),
        ),
      ],
      child: BlocBuilder<LangBloc, LangState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Persona',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              accentColor: Colors.cyanAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              cursorColor: Colors.white60,
            ),
            locale: state.locale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales:
                LangBloc.supportedLanguages.map((lang) => lang.locale),
            localeResolutionCallback: _localeResolutionCallback,
            home: AuthenticationPage(),
            routes: {
              OnboardingScreen.routeName: (_) => OnboardingScreen(),
              HomeScreen.routeName: (_) => HomeScreen(),
            },
          );
        },
      ),
    );
  }

  Locale _localeResolutionCallback(locale, supportedLocales) {
    print("Asked for locale: ${locale.languageCode}");
    Locale resolvedLocale = supportedLocales
            .map((locale) => locale.languageCode)
            .contains(locale.languageCode)
        ? locale
        : supportedLocales.first;
    print("Resolving to ${resolvedLocale.languageCode}");
    return resolvedLocale;
  }
}
