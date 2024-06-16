import 'package:flutter/material.dart';
import 'package:profitpulse/src/global/widgets/title.widget.dart';

class SupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Align children to the start (left) of the column
      children: [
        Align(
          alignment: Alignment.centerLeft, // Align the widget to the left
          child: TitleWidget(title: 'Support'),
        ),
        _buildSupport(),
      ],
    );
  }

  Widget _buildSupport() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Help
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Community'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Community
            },
          ),
        ],
      ),
    );
  }
}
