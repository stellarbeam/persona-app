import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persona/blocs/lang_bloc/lang_bloc.dart';

main() {
  group('LangBloc', () {
    LangBloc langBloc;

    setUp(() {
      langBloc = LangBloc();
    });

    tearDown(() {
      langBloc.close();
    });

    test("initial locale used must be Locale('en')", () {
      expect(langBloc.state, LangState(Locale('en')));
    });

    for (var lang in LangBloc.supportedLanguages) {
      blocTest(
        "locale should be set to Locale('${lang.locale.languageCode}') upon sending LangChanged('${lang.locale.languageCode}') event",
        build: () => langBloc,
        act: (LangBloc bloc) => bloc.add(LangChanged(lang.locale.languageCode)),
        expect: [LangState(Locale(lang.locale.languageCode))],
      );
    }
  });
}
