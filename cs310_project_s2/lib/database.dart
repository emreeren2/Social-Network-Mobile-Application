import 'package:firebase_database/firebase_database.dart';
import 'postObject.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference savePost(PostObject post) {
  var id = databaseReference.child('posts/').push();
  //id.set({post.toJson()});
  return id;
}


