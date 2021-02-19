import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persona/localization/app_localization.dart';
import 'package:persona/widgets/language_changer_icon.dart';

import '../models/role.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/theme_bloc/theme_bloc.dart';

import '../widgets/gradient_button.dart';
import '../widgets/radio_flat_button.dart';
import '../widgets/theme_switcher_icon.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final AuthBloc _authBloc;

  const ProfileCompletionScreen(this._authBloc);

  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  var _formKey = GlobalKey<_ProfileCompletionScreenState>();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  final _workEmailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _branchController = TextEditingController();

  Role _selectedRole = Admin();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final _appLocalizations = AppLocalizations.of(context);
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: state.themeData.backgroundGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  _buildThemeSwitcherIcon(state, context),
                  _buildLanguageChangerIcon(),
                  Column(
                    children: [
                      SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _appLocalizations.translate('complete_profile'),
                          style: TextStyle(
                            color: state.themeData.helpText,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildRoleSelector(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: _buildForm(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Positioned _buildLanguageChangerIcon() {
    return Positioned(
      top: 12,
      right: 50,
      child: LanguageSwitcherIcon(),
    );
  }

  Positioned _buildThemeSwitcherIcon(ThemeState state, BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: ThemeSwitcherIcon(state),
    );
  }

  void _onRoleChanged(value) {
    setState(() {
      // New key created so as to not preserve field focus when changing role
      _formKey = GlobalKey<_ProfileCompletionScreenState>();
      _selectedRole = value;
    });
  }

  Widget _buildRoleSelector() {
    final roles = [Admin(), Boss(), Employee()];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: roles.map((role) {
          return Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RadioFlatButton<Role>(
                label: AppLocalizations.of(context).translate(role.name),
                value: role,
                groupValue: _selectedRole,
                onChanged: _onRoleChanged,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildForm() {
    final _appLocaliztions = AppLocalizations.of(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (_selectedRole is Admin) {
          return _buildAdminForm(state, _appLocaliztions);
        } else if (_selectedRole is Boss) {
          return _buildBossForm(state, _appLocaliztions);
        } else {
          // _selectedRole is Employee
          return _buildEmployeeForm(state, _appLocaliztions);
        }
      },
    );
  }

  InputDecoration _inputDecoration(
      String label, IconData iconData, ThemeState state) {
    return InputDecoration(
      hintText: label,
      icon: Icon(
        iconData,
        color: state.themeData.formFieldText,
      ),
      hintStyle: TextStyle(
        color: state.themeData.formFieldHintText,
      ),
      fillColor: state.themeData.formFieldFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      filled: true,
    );
  }

  Form _buildAdminForm(ThemeState state, AppLocalizations appLocalizations) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _nameController,
              decoration: _inputDecoration(
                appLocalizations.translate('name'),
                Icons.person,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _workEmailController,
              decoration: _inputDecoration(
                appLocalizations.translate('email'),
                Icons.email,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _tokenController,
              decoration: _inputDecoration(
                appLocalizations.translate('token'),
                Icons.code,
                state,
              ),
            ),
            SizedBox(height: 50),
            _buildSubmitButton(() {
              return {
                'name': _nameController.text,
                'role': _selectedRole.name,
                'email': _workEmailController.text,
                'token': _tokenController.text,
              };
            }),
          ],
        ),
      ),
    );
  }

  Form _buildBossForm(ThemeState state, AppLocalizations appLocalizations) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _nameController,
              decoration: _inputDecoration(
                appLocalizations.translate('name'),
                Icons.person,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _workEmailController,
              decoration: _inputDecoration(
                appLocalizations.translate('email'),
                Icons.email,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _deptController,
              decoration: _inputDecoration(
                appLocalizations.translate('department'),
                Icons.domain,
                state,
              ),
            ),
            SizedBox(height: 50),
            _buildSubmitButton(() {
              return {
                'name': _nameController.text,
                'role': _selectedRole.name,
                'email': _workEmailController.text,
                'dept': _deptController.text,
              };
            }),
          ],
        ),
      ),
    );
  }

  Form _buildEmployeeForm(ThemeState state, AppLocalizations appLocalizations) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _nameController,
              decoration: _inputDecoration(
                appLocalizations.translate('name'),
                Icons.person,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _workEmailController,
              decoration: _inputDecoration(
                appLocalizations.translate('email'),
                Icons.email,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _deptController,
              decoration: _inputDecoration(
                appLocalizations.translate('department'),
                Icons.domain,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _jobTitleController,
              decoration: _inputDecoration(
                appLocalizations.translate('job_title'),
                Icons.engineering,
                state,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: state.themeData.formFieldText),
              controller: _branchController,
              decoration: _inputDecoration(
                appLocalizations.translate('branch'),
                Icons.location_on,
                state,
              ),
            ),
            SizedBox(height: 50),
            _buildSubmitButton(() {
              return {
                'name': _nameController.text,
                'role': _selectedRole.name,
                'email': _workEmailController.text,
                'dept': _deptController.text,
                'job-title': _jobTitleController.text,
                'branch': _branchController.text,
              };
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Function getDetails) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return GradientButton(
                gradientColors: state.themeData.buttonGradient,
                label: AppLocalizations.of(context).translate('submit'),
                onPress: () {
                  var details = getDetails();
                  _onSubmit(details);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit(Map<String, String> details) {
    widget._authBloc.add(SubmitProfileDetails(details));
  }
}
