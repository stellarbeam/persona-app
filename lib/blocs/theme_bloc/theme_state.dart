part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;

  ThemeState(this.themeData);

  @override
  List<Object> get props => [themeData];
}
