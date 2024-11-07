import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helloapp/helper/mydate_util.dart';
import 'package:helloapp/models/message.dart';
import 'package:helloapp/screens/apis.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final ms =
        MediaQuery.of(context).size; // Initialize the MediaQuery size here
    return APIs.user.uid == widget.message.fromId
        ? _blackMessage(ms) // Pass the size to the method
        : _blueMessage(ms); // Pass the size to the method
  }

  Widget _blueMessage(Size ms) {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? ms.width * .03
                : ms.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: ms.width * .04, vertical: ms.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 59, 49, 93),
              border: Border.all(
                  color: const Color.fromARGB(255, 128, 127, 127), width: 5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.photo,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Text(
          MyDateUtil.getFormattedTime(
              context: context, time: widget.message.send),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 95, 210)),
        ),
        SizedBox(width: ms.width * .25),
      ],
    );
  }

  Widget _blackMessage(Size ms) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: ms.width * .04),
        if (widget.message.read.isNotEmpty)
          Icon(
            Icons.done_all_rounded,
            color: Colors.teal[800],
            size: 20,
          )
        else
          Icon(
            Icons.done_all_rounded,
            color: const Color.fromARGB(255, 128, 127, 127),
            size: 20,
          ),
        Text(
          MyDateUtil.getFormattedTime(
              context: context, time: widget.message.send),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 95, 210)),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? ms.width * .03
                : ms.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: ms.width * .04,
                vertical: ms.height * .01), // Use ms here
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                  color: const Color.fromARGB(255, 59, 49, 93), width: 5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.photo,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
