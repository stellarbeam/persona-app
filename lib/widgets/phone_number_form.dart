import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:intl_phone_field/phone_number.dart';
import 'package:persona/localization/app_localization.dart';
import '../blocs/theme_bloc/theme_bloc.dart';

class PhoneNumberForm extends StatelessWidget {
  const PhoneNumberForm(
    this._formKey,
    this._validator,
    this._onPhoneChanged,
  );

  final GlobalKey<FormState> _formKey;
  final Function(String) _validator;
  final Function(PhoneNumber) _onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: IntlPhoneField(
              dropDownArrowColor: state.themeData.formFieldText,
              countryCodeTextColor: state.themeData.formFieldText,
              dropdownDecoration: BoxDecoration(
                color: state.themeData.formFieldFill,
                borderRadius: BorderRadius.circular(5),
              ),
              style: TextStyle(
                color: state.themeData.formFieldText,
              ),
              showDropdownIcon: true,
              decoration: _buildPhoneFieldDecoration(context, state),
              initialCountryCode: 'IN',
              onChanged: (phone) => _onPhoneChanged(phone),
              autoValidate: false,
              validator: _validator,
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildPhoneFieldDecoration(
    BuildContext context,
    ThemeState state,
  ) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      hintText: AppLocalizations.of(context).translate('phone_number'),
      hintStyle: TextStyle(
        color: state.themeData.formFieldHintText,
        fontSize: 16,
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: state.themeData.formFieldFill,
    );
  }
}
