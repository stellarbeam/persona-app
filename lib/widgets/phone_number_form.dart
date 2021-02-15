import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _formKey,
        child: IntlPhoneField(
          dropDownArrowColor: Colors.white,
          countryCodeTextColor: Colors.white,
          dropdownDecoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            borderRadius: BorderRadius.circular(5),
          ),
          style: TextStyle(color: Colors.white),
          showDropdownIcon: true,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: "Phone Number",
            hintStyle: TextStyle(
              color: Colors.white.withAlpha(40),
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
            fillColor: Colors.white.withAlpha(40),
          ),
          initialCountryCode: 'IN',
          onChanged: (phone) => _onPhoneChanged(phone),
          autoValidate: false,
          validator: _validator,
        ),
      ),
    );
  }
}

class BrandLabel extends StatelessWidget {
  const BrandLabel(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      alignment: Alignment.center,
      child: Text(
        'persona',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: 'Pacifico',
        ),
      ),
    );
  }
}
