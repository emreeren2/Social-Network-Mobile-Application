import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var currentuser = FirebaseAuth.instance.currentUser;
class FollowingView extends StatefulWidget {

  final UserObject visitedUser;
  FollowingView({Key key,this.visitedUser}) : super(key: key);

  @override
  _FollowingViewState createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  UserObject user_followings = UserObject();
  void getFollowings(){
    _firestore
        .collection('users')
        .doc(widget.visitedUser.userID)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        user_followings = UserObject.fromSnapshot(documentSnapshotx);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _firestore.collection('users').where(FieldPath.documentId, isNotEqualTo: widget.visitedUser.userID).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No users found!'),
              );
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    getFollowings();
                    DocumentSnapshot followings = snapshot.data.docs[index];

                    UserObject user =
                    UserObject.fromSnapshot(followings);
                    //print(user.userID);
                    //print(uservisit.followings);
                    if (user_followings.followings.contains(user.userID)) {
                      return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user.profilePicture),

                          ),
                          title: Text(user.username),
                          onTap: () {setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage(users: user, visitedUserId: user.userID, currentUserId: currentuser.uid, )));
                          });}
                      );
                    }
                    else{return SizedBox();}
                  });
            }
          }
      ),
    );
  }
}

class FollowerView extends StatefulWidget {
  final UserObject visitedUser;
  const FollowerView({Key key,this.visitedUser}) : super(key: key);

  @override
  _FollowerViewState createState() => _FollowerViewState();
}

class _FollowerViewState extends State<FollowerView> {
  UserObject user_followers = UserObject();
  void getFollowers(){
    _firestore
        .collection('users')
        .doc(widget.visitedUser.userID)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        user_followers = UserObject.fromSnapshot(documentSnapshotx);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getFollowers();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: _firestore.collection('users').where(FieldPath.documentId , isNotEqualTo: widget.visitedUser.userID).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No users found!'),

              );
            }
            else {

              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    print(snapshot.data.docs.length);
                    DocumentSnapshot followers = snapshot.data.docs[index];

                    UserObject user =
                    UserObject.fromSnapshot(followers);

                    if (user_followers.followers.contains(user.userID)) {
                      return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user.profilePicture),

                          ),
                          title: Text(user.username),
                          onTap: () {setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage(users: user, visitedUserId: user.userID, currentUserId: currentuser.uid, )));
                          });}
                      );
                    }
                    else{return SizedBox();}
                  });
            }
          }
      ),
    );
  }
}
