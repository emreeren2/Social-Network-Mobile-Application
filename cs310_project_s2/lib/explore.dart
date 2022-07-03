import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/postCard.dart';
import 'package:cs310_project_s2/postObject.dart';
import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:cs310_project_s2/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_comment.dart';
import 'add_post.dart';
import 'feed_page.dart';
import 'notification_page.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userId = FirebaseAuth.instance.currentUser.uid;

var user = FirebaseAuth.instance.currentUser;
UserObject usercurrent = UserObject();

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String defaultUrl = '';


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

  Future<QuerySnapshot> _users;
  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = _firestore.collection("users")
        .where('username', isGreaterThanOrEqualTo: name)
        .where('username', isLessThan: name + 'z')
        .get();

    return users;
  }


 List<PostObject> posts = [];

Icon customIcon = Icon(Icons.search);
Widget customSearchBar = Text("Explore"); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: customSearchBar,
        actions: <Widget>[
          IconButton(
              icon: customIcon,
              onPressed: () {
                setState(() {
                  if (this.customIcon.icon == Icons.search) {
                    /*this.customIcon = Icon(Icons.cancel);*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(values: _users)));
                    /*this.customSearchBar =
                      Container(
                        height: 40.0,
                        child: TextFormField(
                          cursorColor: AppColors.textWhite,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(width: 2,color: AppColors.textWhite),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(width: 1,color: AppColors.box),
                            ),           
                            hintText: "search",
                            hintStyle: TextStyle(color: AppColors.textWhite),
                          ),
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 14.0,
                          ),
                          onChanged: (input){
                            if(input.isNotEmpty){
                              setState(() {
                                _users = searchUsers(input);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SearchPage(values: _users)));
                              });
                            }
                          },
                                         
                        ),
                      );*/
                  }
                  else{
                    this.customIcon = Icon(Icons.search);
                    this.customSearchBar = Text("Explore");
                  }
                });
              }
          ),
        ],
      ),


      body: /*SingleChildScrollView(
        child:
          Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: [
              Column(
                children: posts.map((post) => PostCard(
                          post: post,
                      )).toList(),

              ),   
            ],
          ),        
        ),
      ),*/
      StreamBuilder(
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
                                color: !mypost['usersLiked'].contains(user.uid) ? AppColors.box : Colors.redAccent,
                                splashColor: AppColors.primary,
                                splashRadius: 15.0,
                                iconSize: 16.0,
                                onPressed: () {
                                  setState(() {
                                    if(!mypost['usersLiked'].contains(user.uid)){ // user did not like 

                                      var list = [user.uid];
                                      
                                      _firestore.collection("posts").doc(mypost.id).update({
                                      //  'text': 'like added',
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
                                      //  'text': 'like deleted',
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
                splashColor: AppColors.primary,
                splashRadius: 20.0, 
                onPressed: () { Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => FeedPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                ); 
                              },              
              ),
              IconButton(
                icon: Icon(Icons.explore_outlined), 
                color: AppColors.primary,
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
                                    pageBuilder: (context, animation1, animation2) => ProfilePage(visitedUserId: userId,),
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
class SearchPage extends StatefulWidget {
  Future<QuerySnapshot> values;
  //Future<QuerySnapshot> _users;
  SearchPage({Key key, this.values}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  String currentUserId = auth.currentUser.uid;
  bool isFollowing = false;

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = _firestore.collection("users")
        .where('username', isGreaterThanOrEqualTo: name)
        .where('username', isLessThan: name + 'z')
        .get();

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(height: 40.0,
            child: TextFormField(
              cursorColor: AppColors.textWhite,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(width: 2,color: AppColors.textWhite),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(width: 1,color: AppColors.box),
                ),
                hintText: "search",
                hintStyle: TextStyle(color: AppColors.textWhite),
              ),
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 14.0,
              ),
              onChanged: (input){
                if(input.isNotEmpty){
                  setState(() {
                    widget.values = searchUsers(input);
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(values: _users)));*/
                  });
                }
              },

            ),),
      ),
    body: widget.values == null
    ? Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

    ],
    ),
    )
        : FutureBuilder(
    future: widget.values,
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
    return ListView.builder(
    itemCount: snapshot.data.docs.length,
    itemBuilder: (BuildContext context, int index) {
    UserObject user =
    UserObject.fromSnapshot(snapshot.data.docs[index]);


    return ListTile(
    leading: CircleAvatar(
    radius: 20,
    backgroundImage: user.profilePicture.isEmpty
    ? NetworkImage('https://www.google.com/search?q=manchester+by+the+sea+lee&client=firefox-b-d&source=lnms&tbm=isch&sa=X&ved=2ahUKEwi4ufOltPfwAhVQ_7sIHSaEC4kQ_AUoAXoECAEQAw&biw=1536&bih=750#imgrc=-Ul1FJrEc9BkSM')
        : NetworkImage(user.profilePicture),

    ),
    title: Text(user.username),
    onTap: (){ setState(() {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage(users: user, visitedUserId: user.userID, currentUserId: currentUserId, )));
    });},
    );

    });
    })
    ,
    );
  }
}

class ProfileView extends StatefulWidget {
  String visitedUserId;
  ProfileView({Key key, this.visitedUserId}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}