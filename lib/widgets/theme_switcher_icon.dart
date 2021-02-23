import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc/theme_bloc.dart';
import '../blocs/theme_bloc/theme_data.dart';

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
          onPressed: () {
            BlocProvider.of<ThemeBloc>(context).add(
              ThemeChanged(state.theme == AppTheme.Light
                  ? AppTheme.Dark
                  : AppTheme.Light),
            );
          },
        );
      },
    );
  }
}
