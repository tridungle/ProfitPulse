import 'package:flutter/material.dart';
import 'package:profitpulse/src/global/widgets/title.widget.dart';

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TitleWidget(title: 'About'),
        ),
        _buildAbout(),
      ],
    );
  }

  Widget _buildAbout() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Changelog'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Changelog
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Rate
            },
          ),
        ],
      ),
    );
  }
}
