import 'package:flutter/material.dart';

import 'package:persona/blocs/auth_bloc/auth_bloc.dart';

import '../models/role.dart';

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
      child: Column(
        children: [
          _buildRoleSelector(),
          _buildForm(),
        ],
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
            child: Row(
              children: [
                Radio(
                  value: role,
                  groupValue: _selectedRole,
                  onChanged: _onRoleChanged,
                ),
                Text(role.name),
              ],
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

  Form _buildAdminForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _workEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _tokenController,
              decoration: InputDecoration(labelText: 'Unique Invite Token'),
            ),
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _workEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _deptController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _workEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _deptController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextFormField(
              controller: _branchController,
              decoration: InputDecoration(labelText: 'Company Branch'),
            ),
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
    // TODO: Use a widget named FormButton
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          var details = getDetails();
          _onSubmit(details);
        },
        child: Text('SUBMIT'),
      ),
    );
  }

  void _onSubmit(Map<String, String> details) {
    widget._authBloc.add(SubmitProfileDetails(details));
  }
}
