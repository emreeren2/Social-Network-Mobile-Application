import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/services/storage_service.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../postObject.dart';



class PostService{
  var user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  UserObject userObj = UserObject();

  String mediaUrl = "";
  Set usersLiked = {0} ;
  Set usersComment = {0};

  Future<void> addStatus(String text, PickedFile pickedFile, Set usersLiked, Set usersComment, String userId, String userName, String userPicture) async {

    _firestore.collection("users").doc(userId).get().then((DocumentSnapshot documentSnapshot){
      userObj = UserObject.fromSnapshot(documentSnapshot);
    });

    String userPic = userObj.profilePicture;
    

    var ref = _firestore.collection("posts");

    if(pickedFile == null){
      mediaUrl = '';
      //mediaUrl = 'https://berpel.com/wp-content/uploads/berpel-divider.png';
      //mediaUrl = 'https://www.pinclipart.com/picdir/big/409-4097241_underline-design-and-simple-design-hand-drawn-elements.png';
      //mediaUrl = 'https://freepngimg.com/thumb/web_design/24835-5-horizontal-line-transparent.png';
      //mediaUrl = 'https://png.pngtree.com/png-vector/20200801/ourmid/pngtree-black-proportional-thin-line-png-image_2319163.jpg';
    }
    else{
      mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));
    }

    var documentRef = await ref.add({
      'text': text,
      'image': mediaUrl,
      'usersLiked': usersLiked.toList(),
      'usersComment': usersComment.toList(),
      'userId': userId,
      'username': userName,
      'userpicture': userPicture
    });

    return PostObject(id: documentRef.id, text: text, image: mediaUrl, usersLiked: usersLiked, usersComment: usersComment, userId: userId, username: userName, userpicture: userPicture);
  }

  Future<void> updateStatus(PickedFile pickedFile, String text, String pid) async {
    if(pickedFile != null){
        mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));    
    }
    var ref = _firestore.collection("posts").doc(pid);
    var documentRef = await ref.update({
      'text': text,
      'image': mediaUrl
    });
  }

  Future<void> updateStatusImageUrl(String mediaUrl, String text, String pid) async {

    var ref = _firestore.collection("posts").doc(pid);
    var documentRef = await ref.update({
      'text': text,
      'image': mediaUrl
    });
  }

  Future<void> updateUserPicture(String mediaUrl) async {

    var ref = _firestore.collection("posts").doc();
    var documentRef = await ref.update({
      'userpicture': mediaUrl
    });  

  }

  //status göstermek için
  Stream<QuerySnapshot> showPost() {
    var ref = _firestore.collection("posts").snapshots();

    return ref;
  }

  //status silmek için
  Future<void> removePost(String docId) {
    var ref = _firestore.collection("posts").doc(docId).delete();

    return ref;
  }

  Future<void> addLike(String docId) {
    var ref = _firestore.collection("posts").doc(docId).update({
            'text': 'like added',
            'usersLiked': user.uid
          });
    return ref;
  }
}

