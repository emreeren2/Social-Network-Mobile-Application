import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'explore.dart';
import 'feed_page.dart';
import 'notificationObject.dart';
import 'notificationCard.dart';


List<myNotification> notifications = [
    myNotification(username: "username1",action: "like", post:"lorem ipsum dolar sit amet"),
    myNotification(username: "username1",action: "follow", post:"lorem ipsum dolar sit amet"),
    myNotification(username: "username2",action: "like", post:"lorem ipsum dolar sit amet"),
    myNotification(username: "username2",action: "comment", post:"lorem ipsum dolar sit amet", comment:"helloooo"),
  ];

 class NotificationPage extends StatefulWidget {
   @override
   _NotificationPageState createState() => _NotificationPageState();
 }
 
 class _NotificationPageState extends State<NotificationPage> {
    var user = FirebaseAuth.instance.currentUser;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: AppColors.background,
       appBar: AppBar(
        automaticallyImplyLeading: false,
         backgroundColor: AppColors.primary,
         title: Text("Notifications"), //,style: regularButtonText,
         ),
          body: SingleChildScrollView(
                      child: Card(
                        color: AppColors.background,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: 
                 notifications.map((notification) => NtfCard(
                    notification: notification, 
                    delete: () {

                })).toList(),
             ),
         ),
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
                onPressed: () { },              
              ),
              IconButton(
                icon: Icon(Icons.notifications_outlined), 
                color: AppColors.primary,
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

  