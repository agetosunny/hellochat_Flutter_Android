import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/screens/loginscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        log('User:${APIs.auth.currentUser}');
        log("User Additional Informations:${APIs.auth.currentUser}");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(31, 121, 118, 118),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HELLO...! CHAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: AutofillHints.name,
                  ),
                ),
                SizedBox(height: 20),
                SlideTransition(
                  position: _offsetAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Image.asset(
                      'images/home.png',
                      width: 400,
                      height: 400,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Android Version 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: AutofillHints.location,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity:
                    Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeInOut,
                )),
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
