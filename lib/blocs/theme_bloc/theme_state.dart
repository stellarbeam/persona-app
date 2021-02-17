part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final AppTheme theme;
  AppThemeData get themeData => themeDataCollection[theme];

  ThemeState(this.theme);

  @override
  List<Object> get props => [themeData];
}
