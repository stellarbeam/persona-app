import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/language.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  LangBloc() : super(LangState(Locale('en')));

  static const List<Language> supportedLanguages = [
    Language('English', Locale('en')),
    Language('हिन्दी', Locale('hi')),
  ];

  @override
  Stream<LangState> mapEventToState(
    LangEvent event,
  ) async* {
    if (event is LangChanged) {
      yield LangState(Locale(event._languageCode));
    }
  }
}
