import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc/theme_bloc.dart';

class ThemeSwitcherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.theme == AppTheme.Light
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round,
            color: Colors.white,
          ),
          onPressed: () async {
            AppTheme newTheme =
                state.theme == AppTheme.Light ? AppTheme.Dark : AppTheme.Light;

            BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(newTheme));

            await FirebaseAnalytics().logEvent(
              name: 'theme_change',
              parameters: {
                'theme': newTheme
                    .toString()
                    .split('.')
                    .last, // Obtain the word after '.' i.e. "Light" or "Dark"
              },
            );
          },
        );
      },
    );
  }
}
