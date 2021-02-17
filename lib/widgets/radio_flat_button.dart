import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc/theme_bloc.dart';

class RadioFlatButton<T> extends StatefulWidget {
  final String label;
  final T value;
  final T groupValue;
  final Function(T value) onChanged;

  RadioFlatButton({
    @required this.label,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
  });

  @override
  _RadioFlatButtonState<T> createState() => _RadioFlatButtonState<T>();
}

class _RadioFlatButtonState<T> extends State<RadioFlatButton<T>> {
  // bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.value == widget.groupValue;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.onChanged(widget.value);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? state.themeData.roleTabBackgroundSelected
                  : state.themeData.roleTabBackground,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 30,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: state.themeData.roleTabText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
