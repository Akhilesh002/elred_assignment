import 'package:elred_assignment/screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class Auth {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGoogle() async {
    User? user;

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          Get.snackbar("Account already exist",
              "User with this credentials already present, Please try different credentials", snackPosition: SnackPosition.BOTTOM);
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          Get.snackbar("Invalid credentials", "Please try valid credentials", snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        // handle the error here
        Get.snackbar("Something went wrong", "Please try again later", snackPosition: SnackPosition.BOTTOM);
      }
    }

    return user;
  }

  static Future<void> signOut() async {
    await auth.signOut();
    await _googleSignIn.disconnect();
    Get.snackbar("Logout", "Successfully logout", snackPosition: SnackPosition.BOTTOM);
    Get.offAll(() => const SignInScreen());
  }
}
