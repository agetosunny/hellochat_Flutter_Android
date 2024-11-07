import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/models/chat_user.dart';
import 'package:helloapp/screens/profile_screen.dart';
import 'package:helloapp/widgets/chat_user_card.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      log('Message: $message');
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
            return false; // Prevents the app from popping the screen
          } else {
            return true; // Allows the screen to be popped
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 128, 127, 127),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isSearching
                    ? Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name, E-mail...',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          autofocus: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.7,
                          ),
                          onChanged: (val) {
                            _searchList.clear();
                            for (var i in _list) {
                              if (i.name
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) {
                                _searchList.add(i);
                              }
                            }
                            setState(() {
                              // Update the UI with the search list
                            });
                          },
                        ),
                      )
                    : const Text(
                        'Hellochat',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 29),
                      ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                        });
                      },
                      icon: Icon(
                        _isSearching ? Icons.close_rounded : Icons.search,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.black,
                        size: 33,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              user: APIs.me,
                            )),
                  );
                },
                icon: const Icon(
                  Icons.person_rounded,
                  color: Colors.black,
                  size: 34,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black, // Set scaffold background to black
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 128, 127, 127),
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(
              Icons.add_comment_sharp,
              color: Colors.black,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              _isSearching ? _searchList[index] : _list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No Messages Yet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
