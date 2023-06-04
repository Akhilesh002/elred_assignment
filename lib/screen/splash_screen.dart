import 'package:elred_assignment/provider/login_check_provider.dart';
import 'package:elred_assignment/screen/home_screen.dart';
import 'package:elred_assignment/screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = FirebaseAuth.instance;
  LoginCheckProvider loginCheck = LoginCheckProvider();

  @override
  void initState() {
    super.initState();
    postFrameCall();
  }

  postFrameCall() {
    Future.delayed(2.seconds, () {
      if (loginCheck.isLoggedIn) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => const SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade200,
        child: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                updateData(snapshot);
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              case ConnectionState.none:
                updateData(snapshot);
                return Container();
              case ConnectionState.done:
                updateData(snapshot);
                return Container();
            }
          },
        ),
      ),
    );
  }

  updateData(AsyncSnapshot snapshot) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (snapshot.data != null &&
          snapshot.hasData &&
          (snapshot.data?.email ?? "").isNotEmpty) {
        loginCheck.checkIsLoggedIn(true);
      } else {
        loginCheck.checkIsLoggedIn(false);
      }
    });
  }
}
