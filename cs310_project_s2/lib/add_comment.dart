/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  final DocumentSnapshot post;
  final String post_id;
  final int count;
  AddComment({Key key, this.post_id, this.count, this.post}) : super(key: key);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController statusController = TextEditingController();
  PostService _postService = PostService();
  var user = FirebaseAuth.instance.currentUser;
  var mp;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: AppColors.profileSecondary,
        title: Text('Comments'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {}
          ),
        ],
      ),

      body: StreamBuilder(
        
        //stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        stream: FirebaseFirestore.instance.collection('posts').where('__name__', isEqualTo: widget.post_id).snapshots(), 
        //stream: FirebaseFirestore.instance.collection('posts').where('text', isEqualTo: 'naban').snapshots(), //suan sadece textleri naban olanlari gosteriyoruz 
        builder: (BuildContext context, AsyncSnapshot snapshot) { 
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else{
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs.length, //widget.count, //widget.post['usersComment'].length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot mypost = snapshot.data.docs[index];
                print(widget.post.data());
                print(index);
                print(widget.post['usersComment'][index]);
                    mp = mypost;
                    return Column(
                      children:[ Text(mypost['usersComment'][index].toString())],
                    );
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
                                  "${mypost.id}",
                                  //'asd',
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
                            Text( // comments
                              //"${mypost['usersComment'].toString().split("${user.uid}")}",
                              //"${mypost['text']}",
                              "${mypost['usersComment'][index]}",

                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1,                   
                                color: AppColors.textBlack,
                              ),             
                            ),

                            SizedBox(height: 4.0),  

                            SizedBox(height: 4.0), 

                            /*
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
                                    }
                                    else{ // user already liked
                                        var list = [user.uid];
                                        _firestore.collection("posts").doc(mypost.id).update({
                                          'text': 'like deleted',
                                          'usersLiked': FieldValue.arrayRemove(list)
                                        }); 
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
                                  onPressed: () {  },
                                ),
                                Text(
                                  //'asd'
                                  "${mypost['usersComment'].length}",   
                                ),
                              ],
                            ),*/
                          ],                          
                        ),
                      ),
                    ); 
                    */  
              },
            );
          }
         }
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomSheet:   
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

          Expanded(
              flex: 5,
                  child: Container(
                    height: 40,
                    /*
                    decoration: BoxDecoration(
                        
                        color: AppColors.background,
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),*/
                    child: TextField(
                    controller: statusController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your comment",
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
                  ),
            ),
            Expanded(
              flex: 1,
                child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.box),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  var list = [statusController.text];
                
                  _firestore.collection("posts").doc(mp.id).update({
                    'text': 'comment shared',
                    'usersComment': FieldValue.arrayUnion(list)
                  });
                  print('oldu mu la?');                                 
                  print(user.uid)   ;                         
                },
                  child: Text(
                    'share',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ),
          ],
        ),
    );
  }
}

*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'commentCard.dart';

class AddComment extends StatefulWidget {
  final String post_id;
  AddComment({Key key, this.post_id}) : super(key: key);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController statusController = TextEditingController();
  PostService _postService = PostService();
  var user = FirebaseAuth.instance.currentUser;
  var mp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: AppColors.profileSecondary,
        title: Text('Comments'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {}
          ),
        ],
      ),

      body: 
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomSheet:   
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

          Expanded(
              flex: 5,
                  child: Container(
                    height: 40,
                    child: TextField(
                    controller: statusController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your comment",
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
                  ),
            ),
            Expanded(
              flex: 1,
                child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.box),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  var list = [user.uid, statusController.text];
                
                  _firestore.collection("posts").doc(mp.id).update({
                    'text': 'comment shared',
                    'usersComment': FieldValue.arrayUnion(list)
                  });
                  print('oldu mu la?');                                 
                  print(user.uid)   ;                         
                },
                  child: Text(
                    'share',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ),
          ],
        ),
    );
  }
}
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310_project_s2/services/post_service.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddComment extends StatefulWidget {
  final DocumentSnapshot post;
  final String post_id;
  final int count;
  AddComment({Key key, this.post_id, this.count, this.post}) : super(key: key);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController statusController = TextEditingController();
  PostService _postService = PostService();
  var user = FirebaseAuth.instance.currentUser;
  var mp;


  @override
  Widget build(BuildContext context) {
    
    var ref = FirebaseFirestore.instance.collection('posts/${widget.post_id}/usersComment');//FirebaseFirestore.instance.collection('posts').where('__name__', isEqualTo: widget.post_id);//FirebaseFirestore.instance.collection('posts/${widget.post_id}/usersComment');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        backgroundColor: AppColors.profileSecondary,
        title: Text('Comments'),
      ),

      body: StreamBuilder<QuerySnapshot>(
        //stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        //stream: FirebaseFirestore.instance.collection('posts').where('__name__', isEqualTo: widget.post_id).snapshots(),
        stream: ref.snapshots(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) { 

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else{

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {  
                  
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10000),
                    
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.post['usersComment'].map<Widget>((value){
                        return Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          height: 30,
                          width:  MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.textWhite,
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(value ) 
                        );
                      }).toList(),
                    ),
                  );
                 }
          
            );
            /*
             widget.post['text'].map<Widget>((document) {
              return new ListTile(
                title: new Text(document),
              );
            }).toList();*/
            /*
            List<DocumentSnapshot> list = snapshot.data.docs;
            print('asasdasdasd');
            print(list[1].data());
            return Flexible(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index){
                  return Text(
                    '${list[index].data()}',
                  );
                }
              ),
            );*/
          }
         },
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomSheet:   
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

          Expanded(
              flex: 5,
                  child: Container(
                    height: 40,
                    /*
                    decoration: BoxDecoration(
                        
                        color: AppColors.background,
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),*/
                    child: TextField(
                    controller: statusController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your comment",
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
                  ),
            ),
            Expanded(
              flex: 1,
                child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.box),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    var list = [statusController.text];
                  
                    _firestore.collection("posts").doc(widget.post.id).update({
                      //'text': 'comment shared',
                      'usersComment': FieldValue.arrayUnion(list)

                      
                    });        
                    Fluttertoast.showToast(
                        msg: "Your comment is shared",
                        timeInSecForIosWeb: 2,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 14);      
                    Navigator.pop(context); 
                  });                     
                },
                  child: Text(
                    'share',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ),
          ],
        ),
    );
  }
}
