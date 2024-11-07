import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/screens/menu.dart';
import 'package:helloapp/screens/snackbar.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    // Start animation after a delay of 500 milliseconds
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handle_googlebuttonclick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log(' \nUser: ${user.user}');
        log(' \nUserAdditionalInfo: ${user.additionalUserInfo}');
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Menu()));
        } else {
          APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Menu()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\nsignInWithGoogle: $e');
      Dialogs.showSnackbar(context, "Someting Went Wrong (Check Internet1)");
      return null;
    }
  }

  late Size mq;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            'Hellochat',
            style: TextStyle(
              color: Colors.white,
              fontFamily: AutofillHints.birthdayDay,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 49, 93),
        toolbarHeight: 60,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(198, 48, 48, 0.923),
              const Color.fromRGBO(124, 208, 60, 1),
              const Color.fromRGBO(22, 42, 114, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: _isAnimate ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 2500),
                curve: Curves.easeInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(
                    0,
                    _isAnimate ? -mq.height * 0.07 : 0,
                    0,
                  ),
                  child: Image.asset(
                    'images/icon.png',
                    width: mq.width * 0.5,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.05,
              width: mq.width * 0.9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: () {
                  _handle_googlebuttonclick();
                },
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * 0.06,
                ),
                label: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 19),
                    children: [
                      TextSpan(text: 'Login with '),
                      TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
