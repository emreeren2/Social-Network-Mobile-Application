/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/notification_page.dart';

import 'package:cs310_project_s2/postObject.dart';
import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/services/post_service.dart';

import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_comment.dart';
import 'add_post.dart';
import 'explore.dart';


class FeedPage extends StatefulWidget {

  @override
  
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PostService _postService = PostService();
  var user = FirebaseAuth.instance.currentUser;
  String defaultUrl = '';


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: AppColors.primary,
        title: Text('Feed Page'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {}
          ),
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (context, snapshot) { 
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else{
          return ListView.builder(
            //scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];

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
                                //backgroundImage: post.profilePicture,
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                              Text(
                                "${mypost['userId']}",
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
                                color: Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  setState(() {
                                    if(!mypost['usersLiked'].contains(user.uid)){ // user did not like 

                                      var list = [user.uid];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
                                      print('oldu mu la?');                                 
                                      print(user.uid)   ;     
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
                                      var list = [user.uid];
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        'text': 'like deleted',
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
            },
            );
          }
         }
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: AppColors.primary),
        ),
        //margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(0.0),      
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home_outlined), 
                color: AppColors.primary,
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () {  },              
              ),
              IconButton(
                icon: Icon(Icons.explore_outlined), 
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Explore(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },              
              ),
              /*
              IconButton(
                icon: Icon(Icons.add_circle_outline), 
                iconSize: 40.0,
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () async { await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                     PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Welcome(),
                     transitionDuration: Duration(seconds: 0),
                    ),
                  );
                  /*Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => NotificationPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); */
                              },                 
              ),
              */
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
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => NotificationPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },                
              ),
              IconButton(
                icon: Icon(Icons.person_outline),
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => ProfilePage(visitedUserId: user.uid,),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },           
              ),
            ],
          ),  
        ),
      ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/notification_page.dart';

import 'package:cs310_project_s2/postObject.dart';
import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/userObject.dart';

import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_comment.dart';
import 'add_post.dart';
import 'explore.dart';
import 'welcome.dart';


class FeedPage extends StatefulWidget {

  @override
  
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PostService _postService = PostService();
  var user = FirebaseAuth.instance.currentUser;
  String defaultUrl = '';
  UserObject usercurrent = UserObject();

  bool check = true;
  UserObject uc = UserObject();
  UserObject needed_user = UserObject();

  void getFollowings(){
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
void x(DocumentSnapshot shot){
      _firestore
      .collection('users')
      .doc(shot['userId'])
      .get()
      .then((DocumentSnapshot documentSnapshotx) {
    setState(() {
      uc = UserObject.fromSnapshot(documentSnapshotx);
    });
  });
}

void getUser(DocumentSnapshot shot){
      _firestore
      .collection('users')
      .doc(shot['userId'])
      .get()
      .then((DocumentSnapshot documentSnapshotx) {
    setState(() {
      needed_user = UserObject.fromSnapshot(documentSnapshotx);
    });
  });
}
/*
  void initState() {
    super.initState();
    getFollowings();
  }*/
  @override
  
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: AppColors.primary,
        title: Text('Feed Page'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () async { await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                     PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Welcome(),
                     transitionDuration: Duration(seconds: 0),));        
              },
          ),
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('userId').snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (context, snapshot) { 
          
          if(!snapshot.hasData){
            
            return Center(child: CircularProgressIndicator());
          }
          else{
          getFollowings();
          return ListView.builder(
            //scrollDirection: Axis.vertical,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              DocumentSnapshot mypost = snapshot.data.docs[index];

                if(usercurrent.followings.contains(mypost['userId']) || mypost['userId'] == user.uid){ //usercurrent.followings.contains(mypost['userId'])
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
                                backgroundImage: NetworkImage(mypost['userpicture']),
                                backgroundColor: AppColors.textWhite,
                                radius: 12.0,                  
                              ),
                              SizedBox(width:10.0),
                    
                              InkWell(
                                child: Text(
                                  
                                  "${mypost['username']}",
                                  //"${mypost.id}",
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -1,                   
                                    color: AppColors.secondary,
                                  ),
                                ),
                            onTap: (){
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage(users: usercurrent, visitedUserId: mypost['userId'], currentUserId: user.uid, )));}                               
                              ),
                            ],
                          ),

                          SizedBox(height: 4.0),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 4.0),

                          InkWell(
                            child: Text( // post's text
                              "${mypost['text']}",
                              
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1,                   
                                color: AppColors.textBlack,
                                
                              ),             
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
                                color: !mypost['usersLiked'].contains(user.uid) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  setState(() {
                                    if(!mypost['usersLiked'].contains(user.uid)){ // user did not like 
                                      //color: Colors.transparent;
                                      var list = [user.uid];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                        //'text': 'like added',
                                        'usersLiked': FieldValue.arrayUnion(list)
                                      });
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
                                      //color: Colors.redAccent;
                                      var list = [user.uid];
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: AppColors.primary),
        ),
        //margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(0.0),      
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home_outlined), 
                color: AppColors.primary,
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () {  },              
              ),
              IconButton(
                icon: Icon(Icons.explore_outlined), 
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Explore(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },              
              ),
              /*
              IconButton(
                icon: Icon(Icons.add_circle_outline), 
                iconSize: 40.0,
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () async { await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                     PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Welcome(),
                     transitionDuration: Duration(seconds: 0),
                    ),
                  );
                  /*Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => NotificationPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); */
                              },                 
              ),
              */
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
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => NotificationPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },                
              ),
              IconButton(
                icon: Icon(Icons.person_outline),
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => ProfilePage(visitedUserId: user.uid,),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },           
              ),
            ],
          ),  
        ),
      ),
    );
  }
}
