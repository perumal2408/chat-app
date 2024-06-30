import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text('Dark Theme'),
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
