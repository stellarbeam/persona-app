import 'package:flutter/material.dart';

import '../models/role.dart';

class ProfileCompletionScreen extends StatefulWidget {
  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  var _formKey = GlobalKey<_ProfileCompletionScreenState>();
  final _nameController = TextEditingController();
  final _adminIdController = TextEditingController();
  final _bossIdController = TextEditingController();
  final _workEmailController = TextEditingController();
  final _tokenController = TextEditingController();
  Role _selectedRole = Admin();

  void _onRoleChanged(value) {
    setState(() {
      // New key created so as to not preserve field focus when changing role
      // TODO: Look for possibility of better solution [key for fields?]
      _formKey = GlobalKey<_ProfileCompletionScreenState>();
      _selectedRole = value;
    });
  }

  Widget _buildRoleSelector() {
    var roles = [Admin(), Boss(), Employee()];
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
                controller: _adminIdController,
                decoration: InputDecoration(labelText: 'Admin ID'),
              ),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(labelText: 'Token'),
              ),
            ],
          ),
        ),
      );
    } else if (_selectedRole is Boss) {
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
                controller: _bossIdController,
                decoration: InputDecoration(labelText: 'Boss ID'),
              ),
            ],
          ),
        ),
      );
    } else {
      // _role is Employee
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
                decoration: InputDecoration(labelText: 'Work email'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: _onSubmit,
      child: Text('SUBMIT'),
    );
  }

  void _onSubmit() {
    print("Submitting");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildRoleSelector(),
          Text(_selectedRole.name),
          _buildForm(),
          _buildSubmitButton(),
        ],
      ),
    );
  }
}
