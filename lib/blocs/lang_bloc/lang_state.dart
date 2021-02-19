part of 'lang_bloc.dart';

class LangState extends Equatable {
  final Locale locale;

  LangState(this.locale);

  @override
  List<Object> get props => [locale];
}
