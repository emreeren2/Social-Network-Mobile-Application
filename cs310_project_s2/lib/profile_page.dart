
/*
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/explore.dart';
import 'package:cs310_project_s2/following_followers.dart';
import 'package:cs310_project_s2/services/crashlytics.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:cs310_project_s2/postCard.dart';
import 'package:cs310_project_s2/postObject.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_comment.dart';
import 'add_post.dart';
import 'edit_post.dart';
import 'feed_page.dart';
import 'notification_page.dart';

UserObject user = UserObject(name: "Kermit", email: "kermit@gmail.com", password: "Kermit1337", username: "Kermit", surname: "Kermit", profilePicture: NetworkImage("https://wallpaperboat.com/wp-content/uploads/2020/10/04/55827/hearts-kermit-the-frog-15.jpg"),bio: "Kukla", birthDate: DateTime.utc(2000), followers: ["1000"], followings: ["69"], postCount: 666);
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userId = FirebaseAuth.instance.currentUser.uid;


class ProfilePage extends StatefulWidget{
  UserObject users;
  String visitedUserId;
  String currentUserId = userId;
  bool isFollowing;
  Future<QuerySnapshot> followingDoc;


  ProfilePage({Key key, this.visitedUserId,this.currentUserId,this.isFollowing,this.users}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<PostObject> posts = [];

  double photoradius = 80.0;
  bool isPrivate = false;
  bool isFollowing = false;
  String visitedfollowings;
  String visitedfollowers;
  String currentfollowings;
  String currentfollowers;
  UserObject uservisit = UserObject();
  UserObject  usercurrent = UserObject();

  int visitedPostCount;
  int currentPostCount;

  PostService _postService = PostService();
   String defaultUrl = '';

   void getFollowings(){
    _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
      });
    }); 
  }
  
  @override
  void getcurrentUserInfo()async{
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
        print(usercurrent.profilePicture.toString());
      });
    });
  }
  @override
  void getvisitedUserInfo()async{
    await(_firestore
        .collection('users')
        .doc(widget.visitedUserId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        uservisit = UserObject.fromSnapshot(documentSnapshot);
      });
    }));
  }
  @override
  void numcurrentFollowers() async{

    setState(() {
      currentfollowers = usercurrent.followers.length.toString();
    });
  }
  @override
  void numcurrentFollowings() async{

    setState(() {
      currentfollowings = usercurrent.followings.length.toString();
    });
  }

  @override
  void numvisitedFollowers() async{

    setState(() {
      visitedfollowers = uservisit.followers.length.toString();
    });
  }
  @override
  void numvisitedFollowings() async{

    setState(() {
      visitedfollowings = uservisit.followings.length.toString();
    });
  }
  @override
  followUser() async{
    var followers_list = [widget.currentUserId];
    var followings_list = [widget.visitedUserId];

    var ref_1 = _firestore.collection("users").doc(widget.visitedUserId).update(
        {'followers': FieldValue.arrayUnion(followers_list),});
    /*var documentRef_1 = await ref_1.set({
      'followings': [],
      'followers': [],
    });*/
    var ref_2 = _firestore.collection("users").doc(widget.currentUserId).update(
        {'followings': FieldValue.arrayUnion(followings_list),});
  }
  unfollowUser() async{
    var followers_list = [widget.currentUserId];
    var followings_list = [widget.visitedUserId];

    var ref_1 = _firestore.collection("users").doc(widget.visitedUserId).update(
        {'followers': FieldValue.arrayRemove(followers_list),});
    /*var documentRef_1 = await ref_1.set({
      'followings': [],
      'followers': [],
    });*/
    var ref_2 = _firestore.collection("users").doc(widget.currentUserId).update(
        {'followings': FieldValue.arrayRemove(followings_list),});
  }
  @override
  IsFollowing() async{
  
    //bool isFollowing = false;
    List<DocumentSnapshot> document = ( await _firestore.collection("users").where(FieldPath.documentId, isEqualTo: widget.currentUserId)
        .where("followings", arrayContains: widget.visitedUserId).get()).docs;
    if(document.isNotEmpty){
      setState(() {
        isFollowing = true;
      });

    }
    else{
      setState(() {
        isFollowing = false;
      });

    }
  }
  @override
  IsPrivate() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("users").where(FieldPath.documentId, isEqualTo: widget.visitedUserId)
        .where("private", isEqualTo: true).get()).docs;
    if(document.isNotEmpty){
      setState(() {
        isPrivate = true;
      });

    }
    else{
      setState(() {
        isPrivate = false;
      });

    }
  }

    @override
  numPostVisited() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("posts").where('userId', isEqualTo: widget.visitedUserId)
        .get()).docs;
    if(document.isNotEmpty){
      setState(() {
        visitedPostCount = document.length;
      });

    }
    else{
      setState(() {
        visitedPostCount = 0;
      });

    }
  }

    @override
  numPostCurrent() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("posts").where('userId', isEqualTo: userId)
       .get()).docs;
    if(document.isNotEmpty){
      setState(() {
       currentPostCount = document.length;
      });

    }
    else{
      setState(() {
        currentPostCount = 0;
      });

    }
  }

  Future<void> _showChoiseDialog(BuildContext context, DocumentSnapshot post) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              "Are you sure to delete this post?",
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(15.0))),
            content: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _postService
                            .removePost(post.id);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(width: 30,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )));
      });
}

  @override
  Future<void> _showBio() async {
     if(uservisit.bio.isNotEmpty)
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(uservisit.username.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(uservisit.bio.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



/*
  @override
  void initState() {
    super.initState();
    getvisitedUserInfo();
    getcurrentUserInfo();
    IsFollowing();
    IsPrivate();
    numvisitedFollowers();
    numvisitedFollowings();
    numcurrentFollowers();
    numcurrentFollowings();
  }*/
    @override
    Widget build(BuildContext context) {
      //getFollowings();
      getvisitedUserInfo();
      getcurrentUserInfo();
      IsFollowing();
      IsPrivate();
      numvisitedFollowings();
      numvisitedFollowers();
      numcurrentFollowers();
      numcurrentFollowings();
      numPostVisited();
      numPostCurrent();
      return StreamBuilder<Object>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                automaticallyImplyLeading: false,

                backgroundColor: AppColors.primary,
                title: userId == widget.visitedUserId ?Text("${usercurrent.username}"):Text("${uservisit.name}"),

                actions: userId == widget.visitedUserId
                    ? <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit_profile');
                      }
                  ),
                ]
                    : !isFollowing ? <Widget>[
                  OutlinedButton(child: Text("Follow"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(8.0, 2.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70),),
                    onPressed: () {
                      setState(() {
                        followUser();
                      });
                    },),
                ]
                    : <Widget>[
                  OutlinedButton(child: Text("Unfollow"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(8.0, 2.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70),),
                    onPressed: () {
                      setState(() {
                        unfollowUser();
                      });
                    },),
                ],
              ),

              body: StreamBuilder<Object>(

                  stream: _firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: (){
                                          setState((){
                                              if(photoradius == 80)
                                                photoradius = MediaQuery.of(context).size.width/2.1;
                                                else
                                                  photoradius = 80;
                                                });
                                        },                                          
                                       
                                        child: CircleAvatar(
                                          backgroundImage: userId ==
                                              widget.visitedUserId ? NetworkImage(usercurrent.profilePicture)
                                              : NetworkImage(
                                              uservisit.profilePicture),
                                          radius: photoradius,),
                                      ),
                                      SizedBox(height: 8,),
                                      widget.currentUserId ==
                                          widget.visitedUserId
                                          ? Text(
                                        usercurrent.username, style: TextStyle(
                                          color: AppColors.profileSecondary,
                                          fontSize: 24
                                      ),)
                                          : Text(
                                        uservisit.username, style: TextStyle(
                                          color: AppColors.profileSecondary,
                                          fontSize: 24
                                      ),),

                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? 
                                                    TextButton(
                                                     child: 
                                                     Text("Followings: " + currentfollowings,
                                                  //TODO
                                                      style: TextStyle(
                                                        fontSize: 18
                                                      ),
                                                    ),
                                                    onPressed: () {  
                                                      setState(() {
                                                        Navigator.push(context,MaterialPageRoute(builder: (context) => FollowingView(visitedUser: usercurrent,))); 
                                                      }); },
                                                      )
                                                    : Text(
                                                  "Followings: " +
                                                      visitedfollowings,
                                                  //TODO
                                                  style: TextStyle(
                                                      fontSize: 18),)
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? Text(
                                                  "Followers: " +
                                                      currentfollowers,
                                                  //TODO
                                                  style: TextStyle(
                                                      fontSize: 18),)
                                                    : Text(
                                                  "Followers: " +
                                                      visitedfollowers,
                                                  //TODO
                                                  style: TextStyle(
                                                      fontSize: 18),)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? Text(
                                                    "Posts: " + currentPostCount.toString(),
                                                        //user.postCount.toString(), 
                                                    style: TextStyle(
                                                        fontSize: 18))
                                                    : Text(
                                                    "Posts: " + visitedPostCount.toString(),
                                                        //user.postCount.toString(),
                                                    style: TextStyle(
                                                        fontSize: 18)) // child: Text("Posts: " + user.posts.toString(), style: TextStyle(fontSize: 18)),
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: InkWell(
                                                onTap: _showBio,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text("View bio", style: TextStyle(fontSize: 18),),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(thickness: 1,
                                  color: AppColors.profileSecondary),
                              isPrivate == false || isFollowing == true
                                  ? Padding(
                                padding: EdgeInsets.all(2.0),
                                child: 
                                userId == uservisit.userID ?
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: userId).snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (context, snapshot) { 
          
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
            //return Text('asdasdasda ');
          }
          else{
          //getFollowings();
          return ListView.builder(            
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];
              
              //print('KERITOO');
              //print(mypost['userId']);
/*
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                      },
                      child: Container(
                        height: size.height * .3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${mypost['text']}",
                                style: TextStyle(fontSize: 16, color: AppColors.textBlack),
                                textAlign: TextAlign.center,
                                
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Center(
                                    child: Image(
                                  image: mypost['image'] == ""
                                      ? NetworkImage('')
                                      : NetworkImage(mypost['image']),
                                  //radius: size.height * 0.08,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );   
*/
                
                if(snapshot.hasData){ //usercurrent.followings.contains(mypost['userId'])
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.primary),

                    ),
                    margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row( // stuffs that related with user who shared that post
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(usercurrent.profilePicture),
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                              Text(
                                "${usercurrent.username}",
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,                   
                                  color: AppColors.secondary,
                                ),
                              ),
                              //SizedBox(width:249.0),
                              IconButton(
                              onPressed: (){_showChoiseDialog(context, mypost);}, 
                              icon: Icon(Icons.delete, size: 15, color: AppColors.red,),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.0),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 4.0),

                          Text( // post's text
                            "${mypost['text']}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,                   
                              color: AppColors.textBlack,
                            ),             
                          ),

                          SizedBox(height: 4.0),  

                          Center( 
                            child: mypost['image'] == defaultUrl ? Text(' ',):
                              Image( // post's image
                              //image: post.image,
                              image: NetworkImage(mypost['image'])
                            ),
                          ),

                          SizedBox(height: 4.0), 

                          Row( // buttons
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite), 
                                color: !mypost['usersLiked'].contains(userId) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  print(mypost['userId']);
                                  if(usercurrent.followings.contains(mypost['userId'])){
                                    print('ICERDEMA !!!!!!!!!!!!!!!!!!!!!');
                                  }

                                  setState(() {
                                    if(!mypost['usersLiked'].contains(userId)){ // user did not like 
                                      
                                      var list = [userId];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
                                      //print('oldu mu la?');                                 
                                      //print(user.uid)   ;     
                                      Fluttertoast.showToast(
                                        msg: "You liked this post",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);                          
                                   }
                                   else{ // user already liked
                                      var list = [userId];
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like deleted',
                                        'usersLiked': FieldValue.arrayRemove(list)     
                                      }); 
                                      Fluttertoast.showToast(
                                        msg: "You took back your like",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);       
                                   }  
                                  });
                                },
                              
                              ),
                              Text(
                                '${mypost['usersLiked'].length}',
                                
                              ),

                              SizedBox(width: 10.0),

                              IconButton(
                                icon: Icon(Icons.comment), 
                                iconSize: 16.0,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                onPressed: () {   
                                  String sent_id = mypost.id;
                                  int sent_count = mypost['usersComment'].length;
                                  DocumentSnapshot sent_post = mypost;
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(post_id: sent_id)   ),);
                                  var route = new MaterialPageRoute(builder: (BuildContext context) =>
                                    new AddComment(post_id: sent_id, count: sent_count, post: sent_post,),
                                   );
                                   Navigator.of(context).push(route);
                                  } ,
                              ),
                              Text(
                                //'asd'
                                "${mypost['usersComment'].length}",   
                              ),

                               SizedBox(width: 200.0),

                               
                               IconButton(
                                 onPressed:(){
                                  
                                  Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => EditPost(post_id: mypost.id, post: mypost),
       
                                  ),
                                );                                    
                                 },
                                  icon: Icon(Icons.edit),
                                  iconSize: 16,
                                  splashColor: AppColors.primary,
                                  splashRadius: 15.0,
                               ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );  
                } 
                else{
                  return null;
                }
            },
            );
          }
         }
      ) :
              StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: uservisit.userID).snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (context, snapshot) { 

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
           
          }
          else{
          //getFollowings();
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];
                
                if(snapshot.hasData){ //usercurrent.followings.contains(mypost['userId'])
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.primary),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row( // stuffs that related with user who shared that post
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(uservisit.profilePicture),
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                              Text(
                                "${uservisit.username}",
                                //"${mypost.id}",
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,                   
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.0),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 4.0),

                          Text( // post's text
                            "${mypost['text']}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,                   
                              color: AppColors.textBlack,
                            ),             
                          ),

                          SizedBox(height: 4.0),  

                          Center( 
                            child: mypost['image'] == defaultUrl ? Text(' ',):
                              Image( // post's image
                              //image: post.image,
                              image: NetworkImage(mypost['image'])
                            ),
                          ),

                          SizedBox(height: 4.0), 

                          Row( // buttons
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite), 
                                color:!mypost['usersLiked'].contains(userId) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  print(mypost['userId']);
                                  if(usercurrent.followings.contains(mypost['userId'])){
                                    print('ICERDEMA !!!!!!!!!!!!!!!!!!!!!');
                                  }

                                  setState(() {
                                    if(!mypost['usersLiked'].contains(userId)){ // user did not like 
                                      
                                      var list = [userId];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
                                      //print('oldu mu la?');                                 
                                      //print(user.uid)   ;     
                                      Fluttertoast.showToast(
                                        msg: "You liked this post",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);                          
                                   }
                                   else{ // user already liked
                                      var list = [userId];
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like deleted',
                                        'usersLiked': FieldValue.arrayRemove(list)     
                                      }); 
                                      Fluttertoast.showToast(
                                        msg: "You took back your like",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);       
                                   }  
                                  });
                                },
                              
                              ),
                              Text(
                                '${mypost['usersLiked'].length}',
                                
                              ),

                              SizedBox(width: 10.0),

                              IconButton(
                                icon: Icon(Icons.comment), 
                                iconSize: 16.0,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                onPressed: () {   
                                  String sent_id = mypost.id;
                                  int sent_count = mypost['usersComment'].length;
                                  DocumentSnapshot sent_post = mypost;
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(post_id: sent_id)   ),);
                                  var route = new MaterialPageRoute(builder: (BuildContext context) =>
                                    new AddComment(post_id: sent_id, count: sent_count, post: sent_post,),
                                   );
                                   Navigator.of(context).push(route);
                                  } ,
                              ),
                              Text(
                                //'asd'
                                "${mypost['usersComment'].length}",   
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );  
                } 
                else{
                  return null;
                }
            },
            );
          }
         }
      ),
                              )

                                  : Column(
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Icon(Icons.lock, size: 34.0,),
                                  Text("Private Account", style: TextStyle(
                                      fontSize: 18))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  FeedPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.explore_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Explore(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        iconSize: 40.0,
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()),);}, 
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  NotificationPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_outline),
                        color: AppColors.primary,
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ProfilePage(visitedUserId: userId),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                          //TODO
                          //crashApp();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      );
    }
}
*/

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/explore.dart';
import 'package:cs310_project_s2/following_followers.dart';
import 'package:cs310_project_s2/services/crashlytics.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:cs310_project_s2/postCard.dart';
import 'package:cs310_project_s2/postObject.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_comment.dart';
import 'add_post.dart';
import 'edit_post.dart';
import 'feed_page.dart';
import 'notification_page.dart';

UserObject user = UserObject(name: "Kermit", email: "kermit@gmail.com", password: "Kermit1337", username: "Kermit", surname: "Kermit", profilePicture: NetworkImage("https://wallpaperboat.com/wp-content/uploads/2020/10/04/55827/hearts-kermit-the-frog-15.jpg"),bio: "Kukla", birthDate: DateTime.utc(2000), followers: ["1000"], followings: ["69"], postCount: 666);
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userId = FirebaseAuth.instance.currentUser.uid;


class ProfilePage extends StatefulWidget{
  UserObject users;
  String visitedUserId;
  String currentUserId = userId;
  bool isFollowing;
  Future<QuerySnapshot> followingDoc;


  ProfilePage({Key key, this.visitedUserId,this.currentUserId,this.isFollowing,this.users}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<PostObject> posts = [];

  double photoradius = 80.0;
  bool isPrivate = false;
  bool isFollowing = false;
  String visitedfollowings;
  String visitedfollowers;
  String currentfollowings;
  String currentfollowers;
  UserObject uservisit = UserObject();
  UserObject  usercurrent = UserObject();

  int visitedPostCount;
  int currentPostCount;

  PostService _postService = PostService();
   String defaultUrl = '';

   void getFollowings(){
    _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
      });
    }); 
  }
  
  @override
  void getcurrentUserInfo()async{
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshotx) {
      setState(() {
        usercurrent = UserObject.fromSnapshot(documentSnapshotx);
        print(usercurrent.profilePicture.toString());
      });
    });
  }
  @override
  void getvisitedUserInfo()async{
    await(_firestore
        .collection('users')
        .doc(widget.visitedUserId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        uservisit = UserObject.fromSnapshot(documentSnapshot);
      });
    }));
  }
  @override
  void numcurrentFollowers() async{

    setState(() {
      currentfollowers = usercurrent.followers.length.toString();
    });
  }
  @override
  void numcurrentFollowings() async{

    setState(() {
      currentfollowings = usercurrent.followings.length.toString();
    });
  }

  @override
  void numvisitedFollowers() async{

    setState(() {
      visitedfollowers = uservisit.followers.length.toString();
    });
  }
  @override
  void numvisitedFollowings() async{

    setState(() {
      visitedfollowings = uservisit.followings.length.toString();
    });
  }
  @override
  followUser() async{
    var followers_list = [widget.currentUserId];
    var followings_list = [widget.visitedUserId];

    var ref_1 = _firestore.collection("users").doc(widget.visitedUserId).update(
        {'followers': FieldValue.arrayUnion(followers_list),});
    /*var documentRef_1 = await ref_1.set({
      'followings': [],
      'followers': [],
    });*/
    var ref_2 = _firestore.collection("users").doc(widget.currentUserId).update(
        {'followings': FieldValue.arrayUnion(followings_list),});
  }
  unfollowUser() async{
    var followers_list = [widget.currentUserId];
    var followings_list = [widget.visitedUserId];

    var ref_1 = _firestore.collection("users").doc(widget.visitedUserId).update(
        {'followers': FieldValue.arrayRemove(followers_list),});
    /*var documentRef_1 = await ref_1.set({
      'followings': [],
      'followers': [],
    });*/
    var ref_2 = _firestore.collection("users").doc(widget.currentUserId).update(
        {'followings': FieldValue.arrayRemove(followings_list),});
  }
  @override
  IsFollowing() async{
  
    //bool isFollowing = false;
    List<DocumentSnapshot> document = ( await _firestore.collection("users").where(FieldPath.documentId, isEqualTo: widget.currentUserId)
        .where("followings", arrayContains: widget.visitedUserId).get()).docs;
    if(document.isNotEmpty){
      setState(() {
        isFollowing = true;
      });

    }
    else{
      setState(() {
        isFollowing = false;
      });

    }
  }
  @override
  IsPrivate() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("users").where(FieldPath.documentId, isEqualTo: widget.visitedUserId)
        .where("private", isEqualTo: true).get()).docs;
    if(document.isNotEmpty){
      setState(() {
        isPrivate = true;
      });

    }
    else{
      setState(() {
        isPrivate = false;
      });

    }
  }

    @override
  numPostVisited() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("posts").where('userId', isEqualTo: widget.visitedUserId)
        .get()).docs;
    if(document.isNotEmpty){
      setState(() {
        visitedPostCount = document.length;
      });

    }
    else{
      setState(() {
        visitedPostCount = 0;
      });

    }
  }

    @override
  numPostCurrent() async{
    List<DocumentSnapshot> document = ( await _firestore.collection("posts").where('userId', isEqualTo: userId)
       .get()).docs;
    if(document.isNotEmpty){
      setState(() {
       currentPostCount = document.length;
      });

    }
    else{
      setState(() {
        currentPostCount = 0;
      });

    }
  }

  Future<void> _showChoiseDialog(BuildContext context, DocumentSnapshot post) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              "Are you sure to delete this post?",
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(15.0))),
            content: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _postService
                            .removePost(post.id);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(width: 30,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )));
      });
}

  @override
  Future<void> _showBio() async {
     if(uservisit.bio.isNotEmpty)
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(uservisit.username.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(uservisit.bio.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



/*
  @override
  void initState() {
    super.initState();
    getvisitedUserInfo();
    getcurrentUserInfo();
    IsFollowing();
    IsPrivate();
    numvisitedFollowers();
    numvisitedFollowings();
    numcurrentFollowers();
    numcurrentFollowings();
  }*/
    @override
    Widget build(BuildContext context) {
      //getFollowings();
      getvisitedUserInfo();
      getcurrentUserInfo();
      IsFollowing();
      IsPrivate();
      numvisitedFollowings();
      numvisitedFollowers();
      numcurrentFollowers();
      numcurrentFollowings();
      numPostVisited();
      numPostCurrent();
      return StreamBuilder<Object>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                automaticallyImplyLeading: false,

                backgroundColor: AppColors.primary,
                title: userId == widget.visitedUserId ?Text("${usercurrent.username}"):Text("${uservisit.name}"),

                actions: userId == widget.visitedUserId
                    ? <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit_profile');
                      }
                  ),
                ]
                    : !isFollowing ? <Widget>[
                  OutlinedButton(child: Text("Follow"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(8.0, 2.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70),),
                    onPressed: () {
                      setState(() {
                        followUser();
                      });
                    },),
                ]
                    : <Widget>[
                  OutlinedButton(child: Text("Unfollow"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(8.0, 2.0)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70),),
                    onPressed: () {
                      setState(() {
                        unfollowUser();
                      });
                    },),
                ],
              ),

              body: StreamBuilder<Object>(

                  stream: _firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: (){
                                          setState((){
                                              if(photoradius == 80)
                                                photoradius = MediaQuery.of(context).size.width/2.1;
                                                else
                                                  photoradius = 80;
                                                });
                                        },                                          
                                       
                                        child: CircleAvatar(
                                          backgroundImage: userId ==
                                              widget.visitedUserId ? NetworkImage(usercurrent.profilePicture)
                                              : NetworkImage(
                                              uservisit.profilePicture),
                                          radius: photoradius,),
                                      ),
                                      SizedBox(height: 8,),
                                      widget.currentUserId ==
                                          widget.visitedUserId
                                          ? Text(
                                        usercurrent.username, style: TextStyle(
                                          color: AppColors.profileSecondary,
                                          fontSize: 24
                                      ),)
                                          : Text(
                                        uservisit.username, style: TextStyle(
                                          color: AppColors.profileSecondary,
                                          fontSize: 24
                                      ),),

                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? 
                                                    TextButton(
                                                  child: 
                                                    Text("Followings: " + currentfollowings,
                                                  //TODO
                                                      style: TextStyle(
                                                        fontSize: 18
                                                      ),
                                                    ),
                                                    onPressed: () {setState(() {
                                                      //Future<QuerySnapshot> visiteduser = searchUsers(widget.visitedUserId);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => FollowingView(visitedUser: usercurrent,)));
                                                    });},
                                                      )
                                                    : TextButton(
                                                        child: Text(
                                                  "Followings: " +
                                                          visitedfollowings,
                                                  //TODO
                                                  style: TextStyle(
                                                          fontSize: 18),),
                                                        onPressed: (){
                                                          setState(() {
                                                            //Future<QuerySnapshot> visiteduser = searchUsers(widget.visitedUserId);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => FollowingView(visitedUser: uservisit,)));
                                                          });
                                                        },
                                                      ),
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? TextButton(
                                                      child: Text(
                                                  "Followers: " +
                                                        currentfollowers,
                                                  //TODO
                                                  style: TextStyle(
                                                        fontSize: 18),),
                                                  onPressed: (){
                                                    setState(() {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => FollowerView(visitedUser: usercurrent,)));                                                    
                                                    });
                                                  },
                                                    )
                                                    : TextButton(
                                                      child: Text(
                                                  "Followers: " +
                                                        visitedfollowers,
                                                  //TODO
                                                  style: TextStyle(
                                                        fontSize: 18),),
                                                  onPressed: (){
                                                    setState(() {
                                                      Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => FollowerView(visitedUser: uservisit,)));                                                    
                                                    });

                                                  },
                                                    )
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: widget.currentUserId ==
                                                    widget.visitedUserId ? Text(
                                                    "Posts: " + currentPostCount.toString(),
                                                        //user.postCount.toString(), 
                                                    style: TextStyle(
                                                        fontSize: 18))
                                                    : Text(
                                                    "Posts: " + visitedPostCount.toString(),
                                                        //user.postCount.toString(),
                                                    style: TextStyle(
                                                        fontSize: 18)) // child: Text("Posts: " + user.posts.toString(), style: TextStyle(fontSize: 18)),
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    15),
                                                border: Border.all(
                                                    color: AppColors.primary)
                                            ),
                                            child: InkWell(
                                                onTap: _showBio,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text("View bio", style: TextStyle(fontSize: 18),),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(thickness: 1,
                                  color: AppColors.profileSecondary),
                              isPrivate == false || isFollowing == true
                                  ? Padding(
                                padding: EdgeInsets.all(2.0),
                                child: 
                                userId == uservisit.userID ?
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) { 
          
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else{
          //getFollowings();
          return ListView.builder(            
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];
                
                if(snapshot.hasData){ //usercurrent.followings.contains(mypost['userId'])
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.primary),

                    ),
                    margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row( // stuffs that related with user who shared that post
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(usercurrent.profilePicture),
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                              Text(
                                "${usercurrent.username}",
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,                   
                                  color: AppColors.secondary,
                                ),
                              ),
                              //SizedBox(width:249.0),
                              IconButton(
                              onPressed: (){_showChoiseDialog(context, mypost);}, 
                              icon: Icon(Icons.delete, size: 15, color: AppColors.red,),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.0),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 4.0),

                          Text( // post's text
                            "${mypost['text']}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,                   
                              color: AppColors.textBlack,
                            ),             
                          ),

                          SizedBox(height: 4.0),  

                          Center( 
                            child: mypost['image'] == defaultUrl ? Text(' ',):
                              Image( // post's image
                              //image: post.image,
                              image: NetworkImage(mypost['image'])
                            ),
                          ),

                          SizedBox(height: 4.0), 

                          Row( // buttons
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite), 
                                color: !mypost['usersLiked'].contains(userId) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  print(mypost['userId']);
                                  if(usercurrent.followings.contains(mypost['userId'])){
                                    print('ICERDEMA !!!!!!!!!!!!!!!!!!!!!');
                                  }

                                  setState(() {
                                    if(!mypost['usersLiked'].contains(userId)){ // user did not like 
                                      
                                      var list = [userId];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
                                      //print('oldu mu la?');                                 
                                      //print(user.uid)   ;     
                                      Fluttertoast.showToast(
                                        msg: "You liked this post",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);                          
                                   }
                                   else{ // user already liked
                                      var list = [userId];
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like deleted',
                                        'usersLiked': FieldValue.arrayRemove(list)     
                                      }); 
                                      Fluttertoast.showToast(
                                        msg: "You took back your like",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);       
                                   }  
                                  });
                                },
                              
                              ),
                              Text(
                                '${mypost['usersLiked'].length}',
                                
                              ),

                              SizedBox(width: 10.0),

                              IconButton(
                                icon: Icon(Icons.comment), 
                                iconSize: 16.0,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                onPressed: () {   
                                  String sent_id = mypost.id;
                                  int sent_count = mypost['usersComment'].length;
                                  DocumentSnapshot sent_post = mypost;
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(post_id: sent_id)   ),);
                                  var route = new MaterialPageRoute(builder: (BuildContext context) =>
                                    new AddComment(post_id: sent_id, count: sent_count, post: sent_post,),
                                   );
                                   Navigator.of(context).push(route);
                                  } ,
                              ),
                              Text(
                                //'asd'
                                "${mypost['usersComment'].length}",   
                              ),

                               SizedBox(width: 200.0),

                               
                               IconButton(
                                 onPressed:(){
                                  
                                  Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => EditPost(post_id: mypost.id, post: mypost),
       
                                  ),
                                );                                    
                                 },
                                  icon: Icon(Icons.edit),
                                  iconSize: 16,
                                  splashColor: AppColors.primary,
                                  splashRadius: 15.0,
                               ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );  
                } 
                else{
                  return null;
                }
            },
            );
          }
         }
      ) :
              StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: uservisit.userID).snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (context, snapshot) { 

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
           
          }
          else{
          //getFollowings();
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];
                
                if(snapshot.hasData){ //usercurrent.followings.contains(mypost['userId'])
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.primary),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row( // stuffs that related with user who shared that post
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(uservisit.profilePicture),
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                              Text(
                                "${uservisit.username}",
                                //"${mypost.id}",
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,                   
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.0),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 4.0),

                          Text( // post's text
                            "${mypost['text']}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,                   
                              color: AppColors.textBlack,
                            ),             
                          ),

                          SizedBox(height: 4.0),  

                          Center( 
                            child: mypost['image'] == defaultUrl ? Text(' ',):
                              Image( // post's image
                              //image: post.image,
                              image: NetworkImage(mypost['image'])
                            ),
                          ),

                          SizedBox(height: 4.0), 

                          Row( // buttons
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite), 
                                color:!mypost['usersLiked'].contains(userId) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  print(mypost['userId']);
                                  if(usercurrent.followings.contains(mypost['userId'])){
                                    print('ICERDEMA !!!!!!!!!!!!!!!!!!!!!');
                                  }

                                  setState(() {
                                    if(!mypost['usersLiked'].contains(userId)){ // user did not like 
                                      
                                      var list = [userId];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
                                      //print('oldu mu la?');                                 
                                      //print(user.uid)   ;     
                                      Fluttertoast.showToast(
                                        msg: "You liked this post",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);                          
                                   }
                                   else{ // user already liked
                                      var list = [userId];
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like deleted',
                                        'usersLiked': FieldValue.arrayRemove(list)     
                                      }); 
                                      Fluttertoast.showToast(
                                        msg: "You took back your like",
                                        timeInSecForIosWeb: 2,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[600],
                                        textColor: Colors.white,
                                        fontSize: 14);       
                                   }  
                                  });
                                },
                              
                              ),
                              Text(
                                '${mypost['usersLiked'].length}',
                                
                              ),

                              SizedBox(width: 10.0),

                              IconButton(
                                icon: Icon(Icons.comment), 
                                iconSize: 16.0,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                onPressed: () {   
                                  String sent_id = mypost.id;
                                  int sent_count = mypost['usersComment'].length;
                                  DocumentSnapshot sent_post = mypost;
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(post_id: sent_id)   ),);
                                  var route = new MaterialPageRoute(builder: (BuildContext context) =>
                                    new AddComment(post_id: sent_id, count: sent_count, post: sent_post,),
                                   );
                                   Navigator.of(context).push(route);
                                  } ,
                              ),
                              Text(
                                //'asd'
                                "${mypost['usersComment'].length}",   
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );  
                } 
                else{
                  return null;
                }
            },
            );
          }
         }
      ),
                              )

                                  : Column(
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Icon(Icons.lock, size: 34.0,),
                                  Text("Private Account", style: TextStyle(
                                      fontSize: 18))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  FeedPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.explore_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Explore(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        iconSize: 40.0,
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {   Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()),);}, 
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_outlined),
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  NotificationPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_outline),
                        color: AppColors.primary,
                        splashColor: AppColors.primary,
                        splashRadius: 20.0,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ProfilePage(visitedUserId: userId),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                          //TODO
                          //crashApp();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      );
    }
}