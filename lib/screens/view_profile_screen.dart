import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloapp/helper/mydate_util.dart';
import 'package:helloapp/widgets/profile_image.dart';
import '../../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late Size mq;
  double _fabOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _fabOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onDoubleTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 21, 21, 55),
                Color.fromARGB(255, 31, 7, 95),
                Color.fromARGB(255, 2, 1, 94),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  AppBar(
                    title: Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: mq.width, height: mq.height * .05),
                            Center(
                              child: ProfileImage(
                                size: mq.height * .2,
                                url: widget.user.image,
                              ),
                            ),
                            SizedBox(height: mq.height * .05),
                            Text(
                              widget.user.email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: mq.height * .04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'About: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.user.about,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: mq.height * 0.2,
                left: mq.width * 0.27,
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _fabOpacity,
                  child: FloatingActionButton.extended(
                    onPressed: () {},
                    label: Row(
                      children: [
                        const Text(
                          'Joined On: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          MyDateUtil.getLastMessageTime(
                            context: context,
                            time: widget.user.createdAt,
                            showYear: true,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 24, 31, 44),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
