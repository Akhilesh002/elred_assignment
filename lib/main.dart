import 'package:elred_assignment/provider/login_check_provider.dart';
import 'package:elred_assignment/provider/to_do_provider.dart';
import 'package:elred_assignment/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(),);
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToDoProvider()),
        ChangeNotifierProvider(create: (_) => LoginCheckProvider()),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      )
    );
  }
}
