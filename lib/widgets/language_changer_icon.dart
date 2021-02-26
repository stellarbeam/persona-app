import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/lang_bloc/lang_bloc.dart';

class LanguageSwitcherIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.language,
        color: Colors.white,
      ),
      onSelected: (String languageCode) async {
        BlocProvider.of<LangBloc>(context).add(LangChanged(languageCode));
        await FirebaseAnalytics().logEvent(
          name: 'lang_change',
          parameters: {'lang_code': languageCode},
        );
      },
      itemBuilder: (context) => LangBloc.supportedLanguages.map((lang) {
        return PopupMenuItem<String>(
          child: Text(lang.name),
          value: lang.locale.languageCode,
        );
      }).toList(),
    );
  }
}
