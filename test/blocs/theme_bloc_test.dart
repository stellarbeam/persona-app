import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persona/blocs/theme_bloc/theme_bloc.dart';

main() {
  group('ThemeBloc', () {
    ThemeBloc themeBloc;

    setUp(() {
      themeBloc = ThemeBloc();
    });

    tearDown(() {
      themeBloc.close();
    });

    test('initial theme must be Theme.Light', () {
      expect(themeBloc.state, ThemeState(AppTheme.Light));
    });

    blocTest(
      'theme should be set to AppTheme.Dark upon sending ThemeChanged(AppTheme.Dark) event',
      build: () => themeBloc,
      act: (ThemeBloc bloc) => bloc.add(ThemeChanged(AppTheme.Dark)),
      expect: [ThemeState(AppTheme.Dark)],
    );

    blocTest(
      'theme should be set to AppThemeLight upon sending ThemeChanged(AppTheme.Light) event',
      build: () => themeBloc,
      act: (ThemeBloc bloc) => bloc.add(ThemeChanged(AppTheme.Light)),
      expect: [ThemeState(AppTheme.Light)],
    );
  });
}
