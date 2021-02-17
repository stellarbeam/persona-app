import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc/theme_bloc.dart';

class BrandLabel extends StatelessWidget {
  const BrandLabel(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          alignment: Alignment.center,
          child: Text(
            'persona',
            style: TextStyle(
              color: state.themeData.brandLabelText,
              fontSize: 40,
              fontFamily: 'Pacifico',
            ),
          ),
        );
      },
    );
  }
}
