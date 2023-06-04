import 'package:elred_assignment/screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/auth.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
               // final user = await Auth.signInWithGoogle();
              },
              child: const Text("Sign up with google"),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Already have an account!"),
            //     TextButton(
            //       onPressed: () {
            //         Get.offAll(() => const SignInScreen());
            //       },
            //       child: const Text("Sign in"),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
