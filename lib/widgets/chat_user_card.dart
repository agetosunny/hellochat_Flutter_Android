import 'package:flutter/material.dart';
import 'package:helloapp/helper/mydate_util.dart';
import 'package:helloapp/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloapp/models/message.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/screens/chat_screen.dart';
import 'package:helloapp/widgets/profile_dialogue.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    final cd = MediaQuery.of(context).size;

    return Card(
      color: const Color.fromARGB(255, 128, 127, 127),
      margin: EdgeInsets.symmetric(horizontal: cd.width * .02, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialogue(user: widget.user));
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        height: cd.height * .2,
                        width: cd.width * .15,
                        imageUrl: widget.user.image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(Icons.person_rounded),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.user.name,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'Photo'
                            : _message!.msg
                        : widget.user.about,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.teal[900],
                                borderRadius: BorderRadius.circular(9),
                              ),
                            )
                          : Text(
                              MyDateUtil.getFormattedTime(
                                context: context,
                                time: _message!.send,
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                );
              })),
    );
  }
}
