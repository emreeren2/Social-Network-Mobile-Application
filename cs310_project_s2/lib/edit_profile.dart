/*
import 'package:flutter/material.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'profile_page.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override

  Future<void> SignupUser(String name, String surname, String email, String username, String password) async {
    if(name != null)
    setState(() {
      user.name = name;
    });
    if(surname != null)
      setState(() {
        user.surname = surname;
      });
    if(email != null)
      setState(() {
        user.email = email;
      });
    if(username != null)
      setState(() {
        user.username = username;
      });
    if(password != null)
      setState(() {
        user.password = password;
      });
  }

  String tempName;
  String tempSurname;
  String tempEmail;
  String tempUsername;
  String tempPassword;
  final _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Edit Profile",),
        centerTitle: true,
        backgroundColor: AppColors.profileSecondary,
      ),
      body: SingleChildScrollView(
        child: Form( key: _formKey,
    child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 5,),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(

                      hintText: "Name",

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),

                      )
                    ),
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if(input.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (String input){
                      tempName = input;
                    },
                )
              ),
              SizedBox(width: 5,),
              Expanded(child: TextFormField(
                decoration: InputDecoration(

                    hintText: "Surname",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.profilePrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )
                ),
                keyboardType: TextInputType.text,
                validator: (input) {
                  if(input.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (String input){
                  tempSurname = input;
                },
              )
              ),
              SizedBox(width: 5,)
            ],
          ),
          SizedBox(height: 5,),
          Row(

            children: [
              SizedBox(width: 5,),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "E-mail adress",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.profilePrimary),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if(input.isEmpty) {
                        return 'Please enter your e-mail';
                      }
                      return null;
                    },
                    onSaved: (String input){
                      tempEmail = input;
                    },
                  )
              ),
              SizedBox(width: 5,)
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(backgroundImage: user.profilePicture, radius: 60,),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: AppColors.profileSecondary),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Change Picture", style: TextStyle(color: AppColors.profileSecondary),),
                  ),
                ),
                SizedBox(width: 5,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          Row(children: [
            SizedBox(width: 5,),
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if(input.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (String input){
                    tempUsername = input;
                  },
                )
            ),
            SizedBox(width: 5,),
          ],),
          SizedBox(height: 5,),
          Row(children: [
            SizedBox(width: 5,),
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Password",

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if(input.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (String input){
                    tempPassword = input;
                  },
                )
            ),
            SizedBox(width: 5,),
          ],),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          OutlinedButton(
              onPressed: (){_formKey.currentState.save();
                SignupUser(tempName,tempSurname,tempEmail,tempUsername,tempEmail);
                Navigator.pushNamed(context, '/profile_page');                
                },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Confirm Changes',
                  style: TextStyle(color: AppColors.profileSecondary),
                ),
              ),
            style: OutlinedButton.styleFrom(primary: AppColors.profilePrimary),
          ),
          
          SizedBox(height: 5,),
        ],
      ),
      )
    ));
  }
}
*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_page.dart';
import 'package:cs310_project_s2/services/storage_service.dart';
import 'welcome.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userId = FirebaseAuth.instance.currentUser.uid;




class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  StorageService _storageService = StorageService();

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.getImage(
        source: source,
      );
      setState(()  async {
        image = pickedFile;
        print("dosyaya geldim: $image");
        if (image != null) {
          usercurrent.profilePicture = image;
          String url =  await _storageService.uploadMedia(File(image.path));
          _firestore.collection('users').doc(userId).update({'profilepicture' : url}).then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }

      });
    } catch (e) {
      setState(() {
        _pickImage = e;
        print("Image Error: " + _pickImage);
        if(_pickImage != null){
          _firestore.collection('users').doc(userId).update({'profilepicture' : _pickImage}).then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }
      });
    }
  }
  @override
  Future<void> SignupUser(String name, String surname, String email, String username, String password, String bio) async {
    if(name != null && name != "")
    setState(() {
      user.name = name;
    });
    if(surname != null && surname != "")
      setState(() {
        user.surname = surname;
      });
    if(email != null && email != "")
      setState(() {
        //user.email = email;
        _firestore
            .collection('users')
            .doc(userId)
            .update({ 'email' : email });
      });
    if(username != null && username != "")
      setState(() {
        //user.username = username;
        _firestore
          .collection('users')
          .doc(userId)
          .update({ 'username' : username });
      });
    if(password != null && password != "")
      setState(() {
        //user.password = password;
        _firestore
        .collection('users')
        .doc(userId)
        .update({ 'password' : password});
      }
      );
    if(bio != null && bio != "")
      setState(() {
      //user.password = password;
      _firestore
          .collection('users')
          .doc(userId)
          .update({ 'bio' : bio});
    }
      );
  }
  //Future<bool> _isPrivate = _firestore.collection("users").where("uid", isEqualTo: userId).get().then((QuerySnapshot querySnapshot) {querySnapshot.docs.forEach((doc) {return doc["private"]; });});
  //init(){_buttonIsPrivate = _isPrivate as bool;}
  //bool _buttonIsPrivate = _isPrivate;

  bool _isDelete = false;
  String tempName;
  String tempSurname;
  String tempEmail;
  String tempUsername;
  String tempPassword;
  String tempBio;
  PickedFile image;
  dynamic _pickImage;
  final ImagePicker _pickerImage = ImagePicker();
  UserObject usercurrent = UserObject();
  final _formKey = GlobalKey<FormState>();

  void getcurrentUserInfo()async{
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
        //print(usercurrent.profilePicture.toString());
      });
    });
  }
  @override


  Widget build(BuildContext context) {
    getcurrentUserInfo();
    bool _privacy = usercurrent.private;
    return Scaffold(
      appBar: AppBar(

        title: Text("Edit Profile",),
        centerTitle: true,
        backgroundColor: AppColors.profileSecondary,
      ),
      body: SingleChildScrollView(
        child: Form( key: _formKey,
    child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 5,),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(

                      hintText: "Name",

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),

                      )
                    ),
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if(input.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (String input){
                      tempName = input;
                    },
                )
              ),
              SizedBox(width: 5,),
              Expanded(child: TextFormField(
                decoration: InputDecoration(

                    hintText: "Surname",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.profilePrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )
                ),
                keyboardType: TextInputType.text,
                validator: (input) {
                  if(input.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (String input){
                  tempSurname = input;
                },
              )
              ),
              SizedBox(width: 5,)
            ],
          ),
          SizedBox(height: 5,),
          Row(

            children: [
              SizedBox(width: 5,),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "E-mail adress",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.profilePrimary),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if(input.isEmpty) {
                        return 'Please enter your e-mail';
                      }
                      return null;
                    },
                    onSaved: (String input){
                      tempEmail = input;
                    },
                  )
              ),
              SizedBox(width: 5,),
            ],
          ),
          SizedBox(height: 5,),

          Row(
            children: [
              SizedBox(width: 5,),
              Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Bio",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.profilePrimary),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )
                    ),
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if(input.isEmpty) {
                        return 'Please enter your e-mail';
                      }
                      return null;
                    },
                    onSaved: (String input){
                      tempBio = input;
                    },
                  )
              ),
              SizedBox(width: 5,),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (image != null)
                  CircleAvatar(backgroundImage: FileImage(File(image.path)), radius: 60)
                else
                  CircleAvatar(backgroundImage: NetworkImage(usercurrent.profilePicture), radius: 60),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: AppColors.profileSecondary),
                  ),
                  child: InkWell(
                      onTap: () => _onImageButtonPressed(
                          ImageSource.gallery,
                          context: context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Change Picture", style: TextStyle(color: AppColors.profileSecondary),),
                      )
                  ),
                ),
                SizedBox(width: 5,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          Row(children: [
            SizedBox(width: 5,),
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if(input.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (String input){
                    tempUsername = input;
                  },
                )
            ),
            SizedBox(width: 5,),
          ],),
          SizedBox(height: 5,),
          Row(children: [
            SizedBox(width: 5,),
            Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Password",

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.profilePrimary),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if(input.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (String input){
                    tempPassword = input;
                  },
                )
            ),
            SizedBox(width: 5,),
          ],),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(
              color: AppColors.profileSecondary,
              thickness: 1,
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InputChip(
                  padding: EdgeInsets.all(5),
                  label: Text("Delete Profile"),
                  avatar: Icon(Icons.delete),
                  selected: _isDelete,
                  selectedColor: Colors.purpleAccent,
                  onSelected: (bool selected) {setState(() async {
                    _isDelete = selected;

                    AuthCredential credential = EmailAuthProvider.credential(email: usercurrent.email, password: usercurrent.password);
                    await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
                    try {
                      await FirebaseAuth.instance.currentUser.delete();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'requires-recent-login') {
                        print('The user must reauthenticate before this operation can be executed.');
                      }
                    }
                    await FirebaseAuth.instance.signOut();
                    _firestore.collection("users").doc(userId).delete();
                    print(_isDelete);
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => Welcome(),
                          transitionDuration: Duration(seconds: 0),));
                    _isDelete = false;
                  });},
                  backgroundColor: Colors.lightBlueAccent,
                ),
                InputChip(
                  padding: EdgeInsets.all(5),
                  label: Text("Make Private"),
                  avatar: Icon(Icons.lock),
                  selected: _privacy,
                  selectedColor: Colors.purpleAccent,
                  onSelected: (bool selected) {setState(() {
                    _firestore
                        .collection('users')
                        .doc(userId)
                        .update({ 'private' : selected});
                  });},
                  backgroundColor: Colors.lightBlueAccent,
                )

          ]),
          SizedBox(height: 10,),
          OutlinedButton(
              onPressed: (){_formKey.currentState.save();
                SignupUser(tempName,tempSurname,tempEmail,tempUsername,tempEmail,tempBio);

                Navigator.pop(context);         
                },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Confirm Changes',
                  style: TextStyle(color: AppColors.profileSecondary),
                ),
              ),
            style: OutlinedButton.styleFrom(primary: AppColors.profilePrimary),
          ),
          
          SizedBox(height: 5,),
        ],
      ),
      )
    )

    );
  }
}






