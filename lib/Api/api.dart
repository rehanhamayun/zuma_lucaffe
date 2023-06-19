import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_qr/Pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class WelcomeApi {
  Future registro(String email, String password, String name, String number,
      String type, BuildContext context) async {
    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Loading'),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pop(context);
        if (value.user!.uid.isNotEmpty) {
          if (type == 'user') {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(value.user!.uid)
                .set({
              'nombre': name,
              'numero': number,
              'correo': email,
              'user': 'user',
              'uid': value.user!.uid,
              'points': 0,
              'historialPoints': 0
            });

            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          type: type,
                        )));
          } else {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(value.user!.uid)
                .set({
              'nombre': name,
              'correo': email,
              'numero': number,
              'user': 'empleado',
              'uid': value.user!.uid,
            }).then((value) => WelcomeApi().cerrarSesion());
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Successfully Registered Employee',
              btnOkOnPress: () {},
            ).show();
          }
        } else {
          Navigator.pop(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          title: 'Password too short',
          desc: 'Enter a stronger password',
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          title: 'Registered user',
          desc: 'This email is already in use, come back and log in',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

    // final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future iniciarSesion(
      String emailAddress, String password, context, type) async {
    try {
      if (type == 'gmail') {
         final googleUser = await googleSignIn.signIn();
      // ignore: avoid_print
      print(googleUser);
      if (googleUser == null){ 
        return null;
        }else{
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await auth.FirebaseAuth.instance.signInWithCredential(credential);

        }
        // final GoogleSignInAccount? googleUser =
        //     await GoogleSignIn(scopes: <String>['email']).signIn();
            
        // final GoogleSignInAuthentication googleAuth =
        //     await googleUser!.authentication;

        // final credential = GoogleAuthProvider.credential(
        //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        // await FirebaseAuth.instance
        //     .signInWithCredential(credential);
      } else if (type == 'facebook') {
      //    final result = await FacebookAuth.instance.login();

      // if (result.status == LoginStatus.success) {
      //   final oAuthCredential = auth.FacebookAuthProvider.credential(result.accessToken!.token);
      //   // ignore: unused_local_variable
      //   final userCredential = await auth.FirebaseAuth.instance.signInWithCredential(oAuthCredential);

      // }else if (result.status==LoginStatus.cancelled) {
      //   return null;
      // }
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Loading'),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
            });

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailAddress, password: password)
            .then((value) => Navigator.pop(context));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          title: 'User not found',
          desc:
              'Make sure you have written your email correctly, if so, register first',
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'wrong-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Incorrect password',
          desc: 'Try a different password',
          btnOkOnPress: () {},
        ).show();
      } else if (e.code ==
          'We have blocked all requests from this device due to unusual activity. Try again later') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'You have tried many times',
          desc:
              'You have exceeded the limit of attempts, please come back later',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<UserCredential> signInWithTwitter() async {
  // Create a TwitterLogin instance
  final twitterLogin = TwitterLogin(
    apiKey: 'fGbGmqSjHW5tDUrD1M9aQOolm',//'RXp6bWo3MTBLM1UwWXlrbzh5YmI6MTpjaQ',
    apiSecretKey: 'ojAaGZbO25aEKri9432w7FJHQ04XOtQoL13YImRiPQ2Q4aaewk',//'aWmSoTmDit5yY6YZwcuqOF8RGvIttsECKH8KwwYycy6GlNyTjQ',
    redirectURI: 'flutter-twitter-login://'
  );

  // Trigger the sign-in flow
  final authResult = await twitterLogin.login();

  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: authResult.authToken!,
    secret: authResult.authTokenSecret!,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
}

  Future cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
  }
}
