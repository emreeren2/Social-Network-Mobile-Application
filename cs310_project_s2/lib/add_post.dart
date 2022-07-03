import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController statusController = TextEditingController();
  PostService _postService = PostService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;

  UserObject usercurrent = UserObject();

  final ImagePicker _pickerImage = ImagePicker();
  dynamic _pickImage;
  PickedFile image;

  void getUser(){
    _firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
      });
    }); 
  }

  Widget imagePlace() {
    double height = MediaQuery.of(context).size.height;
    if (image != null) {
      return CircleAvatar(
          backgroundColor: AppColors.profileSecondary,
          backgroundImage: FileImage(File(image.path)),
          radius: height * 0.08);
    } else {
      if (_pickImage != null) {
        return CircleAvatar(
          backgroundColor: AppColors.profileSecondary,
          backgroundImage: NetworkImage(_pickImage),
          radius: height * 0.08,
        );
      } else
        return CircleAvatar(
          backgroundColor: AppColors.profileSecondary,
          //backgroundImage: AssetImage("assets/images/siyah.png"),
          radius: height * 0.08,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
  getUser();
    return Scaffold(
      backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.profileSecondary,
          title: Text("Share Post"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: size.height * .2,

                decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    border: Border.all(color: AppColors.profileSecondary, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                          controller: statusController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Write something...",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(0.0)),
                imagePlace(    ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   /* InkWell(
                        onTap: () => _onImageButtonPressed(
                            ImageSource.camera,
                            context: context),
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: AppColors.profileSecondary,
                        )),*/
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () => _onImageButtonPressed(
                            ImageSource.gallery,
                            context: context),
                        child: Icon(
                          Icons.image,
                          size: 30,
                          color: AppColors.profileSecondary,
                        ))
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 25),
              child: InkWell(
                onTap: () {
                  _postService
                      .addStatus(statusController.text, image, {}, {}, user.uid, usercurrent.username, usercurrent.profilePicture)
                      .then((value) {
                      _postService.updateUserPicture(usercurrent.profilePicture);
                    Fluttertoast.showToast(
                        msg: "Your post is shared",
                        timeInSecForIosWeb: 2,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 14);
                    Navigator.pop(context);
                  });

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textWhite, width: 2,),
                      color: AppColors.profileSecondary,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Text(
                      "Share",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.getImage(
        source: source,
      );
      setState(() {
        image = pickedFile;
        print("dosyaya geldim: $image");
        if (image != null) {}
      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error: " + _pickImage);
      });
    }
  }
}