import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helloapp/models/chat_user.dart';
import 'package:helloapp/screens/view_profile_screen.dart';

class ProfileDialogue extends StatelessWidget {
  const ProfileDialogue({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .7,
        height: mq.height * .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 148, 144, 144),
                fontWeight: FontWeight.bold,
                fontSize: mq.width * .05,
              ),
            ),
            SizedBox(height: mq.height * .02),
            Container(
              width: mq.width * .6,
              height: mq.height * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  width: mq.width * .6,
                  height: mq.height * .3,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person_rounded),
                  ),
                ),
              ),
            ),
            SizedBox(height: mq.height * .03),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.info),
                color: const Color.fromARGB(255, 148, 144, 144),
                iconSize: mq.width * .07,
                padding: EdgeInsets.all(mq.width * .02),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
