part of 'lang_bloc.dart';

abstract class LangEvent extends Equatable {
  const LangEvent();

  @override
  List<Object> get props => [];
}

class LangChanged extends LangEvent {
  final String _languageCode;
  LangChanged(this._languageCode);

  @override
  List<Object> get props => [_languageCode];
}
