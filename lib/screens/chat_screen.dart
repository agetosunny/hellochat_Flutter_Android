import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloapp/helper/mydate_util.dart';
import 'package:helloapp/models/chat_user.dart';
import 'package:helloapp/models/message.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/screens/view_profile_screen.dart';
import 'package:helloapp/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onDoubleTap: () => Navigator.pop(context),
      child: WillPopScope(
        onWillPop: () async {
          if (_showEmoji) {
            setState(() => _showEmoji = false);
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          // Remove SafeArea and position the app bar correctly
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(mq.height * .07),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(255, 128, 127, 127),
              flexibleSpace: _appbar(mq),
              elevation: 0,
              systemOverlayStyle:
                  SystemUiOverlayStyle.dark, // To handle system status bar
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    log('Snapshot data: ${snapshot.data?.docs}');

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading messages'));
                    }

                    if (!snapshot.hasData ||
                        snapshot.data?.docs.isEmpty == true) {
                      return _buildEmptyMessage(widget.user.name);
                    }

                    final data = snapshot.data!.docs;
                    _list =
                        data.map((e) => Message.fromJson(e.data())).toList();

                    // No need to scroll to bottom here
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: _list.length,
                      padding: EdgeInsets.only(top: mq.height * .03),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MessageCard(message: _list[index]);
                      },
                    );
                  },
                ),
              ),
              if (_isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              _chatInput(),
              if (_showEmoji)
                Container(
                  color: const Color.fromARGB(255, 128, 127, 127),
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      bgColor: Colors.black,
                      columns: 8,
                      initCategory: Category.ACTIVITIES,
                      emojiSizeMax: 30,
                    ),
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        // Append emoji only if it's not already the last character
                        if (!_textController.text.endsWith(emoji.emoji)) {
                          _textController.text += emoji.emoji;
                          _textController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _textController.text.length),
                          );
                        }
                      });
                      // Keep the keyboard open
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar(Size mq) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(
                children: [
                  SizedBox(width: mq.width * 0.09),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        width: mq.height * .1,
                        height: mq.height * .1,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child:
                              Icon(Icons.person_rounded, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: mq.width * 0.02),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list.isNotEmpty ? list[0].name : widget.user.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: mq.width * .08,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online..'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: const Color.fromARGB(255, 128, 127, 127),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() => _showEmoji = !_showEmoji);
                  },
                  icon: const Icon(Icons.emoji_emotions_rounded,
                      color: Colors.black),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() => _isUploading = true);
                      await APIs.sendChatImage(widget.user, File(image.path));
                      setState(() => _isUploading = true);
                    }
                  },
                  icon:
                      const Icon(Icons.camera_alt_rounded, color: Colors.black),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = false);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.file_copy_rounded, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_rounded, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              // Send the message
              APIs.sendMessage(widget.user, _textController.text, Type.text);

              // Clear the text field
              _textController.clear();

              // Scroll to the bottom after sending the message
              _scrollToBottom();
            }
          },
          color: const Color.fromARGB(255, 128, 127, 127),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(3.0),
          minWidth: 0,
          height: 0,
          child: const Icon(
            Icons.send_rounded,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMessage(String userName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No messages here',
            style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 128, 127, 127),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Say Hi to $userName',
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '👋🏻',
            style: TextStyle(fontSize: 40),
          )
        ],
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
