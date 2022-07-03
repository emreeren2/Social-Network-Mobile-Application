import 'package:cs310_project_s2/postObject.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {

  final PostObject post;
  PostCard({this.post});

  @override
  Widget build(BuildContext context) {
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
                  post.username,
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
              post.text,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                letterSpacing: -1,                   
                color: AppColors.textBlack,
              ),             
            ),

            SizedBox(height: 4.0),  

            Center(
              child: Image( // post's image
                //image: post.image,
                image: NetworkImage('https://images.megapixl.com/6244/62449823.jpg')
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
                  onPressed: () { },
                
                ),
                Text(
                  'as'
                  //'${post.like}',
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
                  'as'
                  //'${post.commentCount}'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}