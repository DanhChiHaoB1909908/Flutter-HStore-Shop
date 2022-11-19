import 'package:flutter/material.dart';

import '../widgets/auth-card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'AuthScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        height: size - MediaQuery.of(context).padding.bottom,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white38,
                  border: Border.all(color: Colors.black, width: 0.5)),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              child: Text(
                "H-STORE",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
            SizedBox(height: 15),
            AuthCard(),
          ],
        ),
      ),
    );
  }
}
