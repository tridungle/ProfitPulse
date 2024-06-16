import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:profitpulse/src/modules/profile/widgets/about.widget.dart';
import 'package:profitpulse/src/modules/profile/widgets/setting.widget.dart';
import 'package:profitpulse/src/modules/profile/widgets/support.widget.dart';
import 'package:profitpulse/src/modules/auth/providers/auth.provider.dart';
import 'package:profitpulse/src/modules/auth/login.screen.dart';

class ProfileScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut(BuildContext context) async {
    await _googleSignIn.signOut();
    // Navigate to the login screen after sign out
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    String? photoUrl = currentUser?.photoURL;
    String? displayName = currentUser?.displayName ?? 'Unknown user';
    String? email = currentUser?.email ?? 'Hidden email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SettingSection(),
              SizedBox(height: 20),
              SupportSection(),
              SizedBox(height: 20),
              AboutSection(),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Make the SizedBox full width
                child: ElevatedButton(
                  onPressed: () => _handleSignOut(context),
                  child: Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
