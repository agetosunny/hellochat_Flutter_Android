import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helloapp/screens/apis.dart';
import 'package:helloapp/screens/loginscreen.dart';
import 'package:helloapp/screens/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final pd = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 59, 49, 93),
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: AutofillHints.creditCardName,
              fontSize: 26,
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 189, 41, 63),
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.updateActiveStatus(false);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Loginscreen()),
                    (route) => false,
                  );
                  APIs.auth = FirebaseAuth.instance;
                });
              });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 45, 38, 68),
                  Color.fromARGB(255, 59, 49, 93),
                  Color.fromARGB(255, 92, 76, 148),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: pd.width * .05),
                      child: Column(
                        children: [
                          SizedBox(
                            width: pd.width,
                            height: pd.height * .05,
                          ),
                          Stack(
                            children: [
                              _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          pd.height * .15),
                                      child: Image.file(
                                        File(_image!),
                                        height: pd.height * .25,
                                        width: pd.width * .5,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          pd.height * .15),
                                      child: CachedNetworkImage(
                                        key: ValueKey(widget.user.image),
                                        height: pd.height * .25,
                                        width: pd.width * .5,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.user.image,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                child:
                                                    Icon(Icons.person_rounded)),
                                      ),
                                    ),
                              Positioned(
                                bottom: 8,
                                right: -13,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: _showBottomSheet,
                                  color: Colors.black,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: pd.height * .03,
                          ),
                          Text(
                            widget.user.email,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                          SizedBox(
                            height: pd.height * .03,
                          ),
                          TextFormField(
                            onSaved: (val) => APIs.me.name = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : 'Required Field',
                            initialValue: widget.user.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_2_rounded,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Username',
                              hintStyle: const TextStyle(color: Colors.white),
                              label: const Text(
                                'User',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: pd.height * .03,
                          ),
                          TextFormField(
                            onSaved: (val) => APIs.me.about = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : 'Required Field',
                            initialValue: widget.user.about,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Hey! I am Using Hellochat...',
                              hintStyle: const TextStyle(color: Colors.white),
                              label: const Text(
                                'About',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: pd.height * .05,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                APIs.updateUserInfo().then((value) {
                                  Dialogs.showSnackbar(
                                      context, 'PROFILE UPDATED!');
                                });
                              }
                            },
                            label: const Text(
                              'Update',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: Size(pd.width * .5, pd.height * .06),
                              backgroundColor: Colors.black,
                            ),
                            icon: const Icon(
                              Icons.draw,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        final pd = MediaQuery.of(context).size;
        return Container(
          height: pd.height * .35,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: pd.height * .025),
              Text(
                'Update Profile',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: pd.width * .1),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: Size(pd.width * .4, pd.height * .2),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(
                            context); // Close the bottom sheet after selection
                      }
                    },
                    child: Image.asset('images/cam.png'),
                  ),
                  SizedBox(width: pd.width * .05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: Size(pd.width * .4, pd.height * .2),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(
                            context); // Close the bottom sheet after selection
                      }
                    },
                    child: Image.asset('images/files.png'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
