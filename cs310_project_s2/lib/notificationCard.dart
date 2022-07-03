
import 'package:cs310_project_s2/utils/styles.dart';
import 'package:flutter/material.dart';
import 'notificationObject.dart';
import 'notification_page.dart';


class NtfCard extends StatefulWidget{
  final myNotification notification;
  final Function delete;
  NtfCard({this.notification, this.delete});

  @override
  _NtfCardState createState() => _NtfCardState();
}

class _NtfCardState extends State<NtfCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible( //for deleting notifitications with swiping
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {  setState(() {
                        notifications.remove(widget.notification);
                        Navigator.pushReplacement(
                                  context, 
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => NotificationPage(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                );                         
                          });},
          child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.notification.action == "like")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.favorite,size: 20.0),
                          SizedBox(width: 10.0, height: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                   CircleAvatar(
                                      backgroundImage: NetworkImage('https://www.birdunyafilm.co/wp-content/uploads/2019/01/manchester-by-the-sea-1.jpg'),
                                      radius: 12.0,
                                  ),
                                  SizedBox(width: 10.0, height: 10.0,),
                                  Text(widget.notification.username + " liked your post",style: regularText2,),
                                ],
                              ),
                              Text(widget.notification.post,style: regularText2,),
                            ],
                          ),
                         
                        ],
                      ),
                  
                    ),
              if(widget.notification.action == "follow")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person_add,size:20.0),
                        SizedBox(width: 10.0, height: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage('https://www.birdunyafilm.co/wp-content/uploads/2019/01/manchester-by-the-sea-1.jpg'), //image comes from the user class
                                    radius: 12.0,
                                  ),
                                  SizedBox(width: 10.0, height: 10.0,),
                                  //onPressed should check the user already followed or not, if user has not followed after the button pressed, should be followed
                                  OutlinedButton(child: Text("Follow"), style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(8.0, 2.0)) ,foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),), onPressed: () {  },),
                                ],
                              ),
                              Text(widget.notification.username + " followed you",style: regularText2,),
                            ],
                          ),
                      ],
                    ),
                  ),
              if(widget.notification.action == "comment")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.comment,size: 20.0),
                          SizedBox(width: 10.0, height: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                   CircleAvatar(
                                      backgroundImage: NetworkImage('https://www.birdunyafilm.co/wp-content/uploads/2019/01/manchester-by-the-sea-1.jpg'),
                                      radius: 12.0,
                                  ),
                                  SizedBox(width: 10.0, height: 10.0,),
                                  Text(widget.notification.username + " comment out your post",style: regularText2,),
                                ],
                              ),
                              SizedBox(width: 10.0, height: 10.0,),
                              Text(widget.notification.comment,style: regularText2),
                              Card(
                                margin: EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
                                
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.notification.post,style: regularText2,),
                                ),

                              ),
                            ],
                          ),
                        ],
                      ),
                  
                    ),
            ],
          ),
        ),
        background: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.red) ,child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Delete",style: regularText,),
          ],
        ),),
    );
  
  }
}