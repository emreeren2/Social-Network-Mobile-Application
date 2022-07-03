//import 'dart:html';
//import 'package:cs310_project_s2/userObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

int getLikeCount(Set usersLiked){
  int size = usersLiked.length;
  return size;
}

int getCommentCount(Set usersComment){
  int size = usersComment.length;
  return size;
}

class PostObject{
  String id;
  String username;
  String userId;
  String userpicture;
  //NetworkImage profilePicture; // it should ne change to AssetImage
  //UserObject user; // instead of username and pp, using UserObject is better option

  String text;
  String image; // it should ne change to AssetImage


  DateTime date;
  Set usersLiked = {};
  Set usersComment = {};
  int likeCount;
  int commentCount;


  PostObject({this.id, this.text, this.image, this.usersLiked, this.usersComment, this.likeCount, this.commentCount, this.userId, this.username, this.userpicture});

  void likePost(User user){
    if(this.usersLiked.contains(user.uid)){
      this.usersLiked.remove(user.uid);
    }
    else{
      this.usersLiked.add(user.uid);
    }
  }
}
