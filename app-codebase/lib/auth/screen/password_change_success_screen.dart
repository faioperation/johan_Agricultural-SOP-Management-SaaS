import 'package:farm_check_support/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

class PasswordUpdatedSuccessScreen extends StatelessWidget {
  const PasswordUpdatedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E9),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: h * 0.1),

            /// LOGO
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: h * 0.16,
              ),
            ),

            SizedBox(height: h * 0.05),

            /// TITLE
            Text(
              'Password Updated\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: h * 0.015),

            /// SUBTITLE
            Text(
              'Your new password has been saved.\nYou can now continue securely.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.035,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const Spacer(),

            /// SIGN IN BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: w * 0.042,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }
}
