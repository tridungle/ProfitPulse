import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/home/home.view.dart';
import 'package:provider/provider.dart';
import 'package:profitpulse/src/modules/auth/providers/auth.provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await authProvider.signInWithGoogle();
                if (authProvider.isLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home',)),
              );
            }
              },
              child: Text('Login with Google'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await authProvider.signInWithFacebook();
            //   },
            //   child: Text('Login with Facebook'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await authProvider.signInWithApple();
            //   },
            //   child: Text('Login with Apple'),
            // ),
          ],
        ),
      ),
    );
  }
}
