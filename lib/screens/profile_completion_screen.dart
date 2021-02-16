import 'package:flutter/material.dart';

import '../models/role.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

import '../widgets/gradient_button.dart';
import '../widgets/radio_flat_button.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF01CCB4),
            Color(0xFF006CEC),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Complete your profile',
                  style: TextStyle(
                    color: Colors.white,
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
        ),
      ),
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
                label: role.name,
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
    if (_selectedRole is Admin) {
      return _buildAdminForm();
    } else if (_selectedRole is Boss) {
      return _buildBossForm();
    } else {
      // _selectedRole is Employee
      return _buildEmployeeForm();
    }
  }

  InputDecoration _inputDecoration(String label, IconData iconData) {
    return InputDecoration(
      hintText: label,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      hintStyle: TextStyle(
        color: Colors.white.withAlpha(80),
      ),
      fillColor: Colors.white.withAlpha(40),
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

  Form _buildAdminForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Name', Icons.person),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _workEmailController,
              decoration: _inputDecoration('Email', Icons.email),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _tokenController,
              decoration: _inputDecoration('Unique Invite Token', Icons.code),
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

  Form _buildBossForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Name', Icons.person),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _workEmailController,
              decoration: _inputDecoration('Email', Icons.email),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _deptController,
              decoration: _inputDecoration('Department', Icons.domain),
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

  Form _buildEmployeeForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Name', Icons.person),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _workEmailController,
              decoration: _inputDecoration('Email', Icons.email),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _deptController,
              decoration: _inputDecoration('Department', Icons.domain),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _jobTitleController,
              decoration: _inputDecoration('Job Title', Icons.engineering),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _branchController,
              decoration: _inputDecoration('Company Branch', Icons.location_on),
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
          GradientButton(
            gradientColors: [
              Color(0xFF00C2DC),
              Color(0xFF0094FF),
            ],
            label: "Submit",
            onPress: () {
              var details = getDetails();
              _onSubmit(details);
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
