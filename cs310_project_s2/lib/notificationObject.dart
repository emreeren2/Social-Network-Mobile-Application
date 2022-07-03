
// ignore: camel_case_types
class myNotification{

  String username; //should be come from postObjects
  String action; //should check the count of followers, likes and comments
  String post; //should be come from postObjects
  String comment; //should be come from the comments[] in postObjects

  myNotification({this.username,this.action,this.post,this.comment});
}