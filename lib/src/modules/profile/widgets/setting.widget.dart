import 'package:flutter/material.dart';
import 'package:profitpulse/src/global/widgets/title.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SettingSection extends StatefulWidget {
  @override
  _SettingSectionState createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Align children to the start (left) of the column
      children: [
        Align(
          alignment: Alignment.centerLeft, // Align the widget to the left
          child: TitleWidget(title: 'Settings'),
        ),
        _buildSettings(),
      ],
    );
  }

Future<void> _updateSwitchValue(bool value) async {
    // Update the switch value in Firestore
    return FirebaseFirestore.instance
        .collection('settings')
        .doc('user_settings')
        .update({'faceIdEnabled': value});
  }
  Future<void> _handleFaceId(bool value) async {
    setState(() {
      _isSwitched = value;
      _updateSwitchValue(value);
    });
  }

  Widget _buildSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Face ID'),
            trailing: Switch(
                value: _isSwitched,
                onChanged: (bool value) => _handleFaceId(value)),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Language settings
            },
          ),
        ],
      ),
    );
  }
}
