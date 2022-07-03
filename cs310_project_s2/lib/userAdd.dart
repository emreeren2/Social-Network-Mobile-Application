import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/userObject.dart';


class UserAdd {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String uid, String username, String email, String password) async {
    bool private = false;
    var ref = _firestore.collection("users").doc(uid);
    var documentRef = await ref.set({
      'username': username,
      'email': email,
      'password': password,
      'profilepicture': "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg",
      'followings': [],
      'followers': [],
      'posts': [],
      'private': private,
      'bio': ""
    });
    return UserObject(
      userID: uid,
      username: username,
      email: email,
      profilePicture: "",
      password: password,
    );

  }

  Future<void> addGoogleUser(String uid, String username, String email, String profilepicture) async {
    bool private = false;
    var ref = _firestore.collection("users").doc(uid);
    var documentRef = await ref.set({
      'username': username,
      'email': email,
      'password': '',
      'profilepicture': profilepicture,
      'followings': [],
      'followers': [],
      'posts': [],
      'private': private,
      'bio': ""
    });
    
    return UserObject(
      userID: uid,
      username: username,
      email: email,
      profilePicture: profilepicture,
      password: '',
    );

  }

  Future<void> updateUser(String uid, String password) async {
    bool private = false;
    var ref = _firestore.collection("users").doc(uid);
    var documentRef = await ref.update({
      'password': password,
    });

  }
}