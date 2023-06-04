import 'package:elred_assignment/screen/home_screen.dart';
import 'package:elred_assignment/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Container(
        color: Colors.blue.shade200,
        height: Get.height - kToolbarHeight,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final user = await Auth.signInWithGoogle();
                if(user != null) {
                  Get.offAll(() => HomeScreen());
                }
              },
              child: const Text("Sign In with google"),
            ),
          ],
        ),
      ),
    );
  }
}
