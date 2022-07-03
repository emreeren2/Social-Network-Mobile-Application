/*
import 'package:flutter/material.dart';

class UserObject{
  String username;
  String email;
  String password;

  String name;
  String surname;
  NetworkImage profilePicture;

  String bio;
  DateTime birthDate;

  int followers;
  int followings;
  int postCount;


  UserObject({this.username, this.email, this.password,
              this.name, this.surname, this.profilePicture, 
              this.bio, this.birthDate,
              this.followers, this.followings, this.postCount});

}
*/



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserObject{
  bool private;
  String userID;
  String username;
  String email;
  String password;

  String name;
  String surname;
  dynamic profilePicture;

  String bio;
  DateTime birthDate;

  List<dynamic> followers = [];
  List<dynamic> followings = [];
  int postCount;


  UserObject({this.userID ,this.username, this.email, this.password,
              this.name, this.surname, this.profilePicture, 
              this.bio, this.birthDate,
              this.followers, this.followings, this.postCount, this.private});

  factory UserObject.fromSnapshot(DocumentSnapshot snapshot){
    return UserObject(
      userID: snapshot.id,
      username: snapshot["username"],
      email: snapshot["email"],
      password: snapshot["password"],
      profilePicture: snapshot["profilepicture"],
      followers: snapshot["followers"],
      followings: snapshot["followings"],
      bio: snapshot["bio"],
      private: snapshot["private"]
    );
  }
}
