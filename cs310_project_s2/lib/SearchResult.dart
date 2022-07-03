import 'package:cs310_project_s2/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:cs310_project_s2/userObject.dart';
import 'package:cs310_project_s2/postObject.dart';

//SearchResult -> {SearchUser, SearchPost}
//Cards -> {SearchPostCard, SearchUserCard}

class SearchResult{
  String resultText;
  String type;

  SearchResult({this.resultText})
  {
    type = "SUPER";
  }
}

class SearchUser extends SearchResult{

  UserObject user;

  SearchUser({this.user})
  {
    super.type = "USER";
    super.resultText = user.username;
  }
}

class SearchPost extends SearchResult{

  PostObject post;
  SearchPost({this.post})
  {
    super.type = "POST";
    super.resultText = post.text;
  }
}

class SearchPostCard extends StatelessWidget {

  final SearchPost searchPost;
  SearchPostCard({this.searchPost});

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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              //backgroundImage: searchPost.post.profilePicture,
              backgroundColor: AppColors.textWhite,
              radius: 20.0,
            ),
            SizedBox(width:10.0),
            Text(
              searchPost.post.username,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                letterSpacing: -1,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(width: 8.0),

            Text( // post's text
              searchPost.post.text,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                letterSpacing: -1,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchUserCard extends StatelessWidget {

  final SearchUser searchUser;
  SearchUserCard({this.searchUser});

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
        child: Row( // stuffs that related with user who shared that post
          children: <Widget>[
            CircleAvatar(
              backgroundImage: searchUser.user.profilePicture,
              backgroundColor: AppColors.textWhite,
              radius: 30.0,
            ),
            SizedBox(width:10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  searchUser.user.name + " " + searchUser.user.surname,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  searchUser.user.username,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
