import 'package:cs310_project_s2/change_password.dart';
import 'package:cs310_project_s2/following_followers.dart';
import 'package:cs310_project_s2/profile_page.dart';
import 'package:cs310_project_s2/signup.dart';
import 'package:cs310_project_s2/walkthrough.dart';
import 'package:cs310_project_s2/welcome.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';

import 'edit_profile.dart';
import 'explore.dart';
import 'login.dart';
import 'feed_page.dart';
import 'notification_page.dart';
import 'edit_post.dart';



/*
void main() => runApp(MaterialApp(
    routes:{
        '/': (context) => WalkThrough(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => Login(),  
        '/signup': (context) => SignUp(),    
        '/explore': (context) => Explore(), 
        '/feed_page': (context) => FeedPage(),  
        '/notification_page': (context) => NotificationPage(),   
        '/profile_page': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfile(),                
    },
  ));
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print('Cannot connect to firebase: '+snapshot.error);
          return MaterialApp(
            home: WalkThrough(),
          );          
        }

        if(snapshot.connectionState == ConnectionState.done) {
          print('Firebase connected');
          return AppBase();
        }
        
        print('naban');
        return MaterialApp(
          home: WalkThrough(),
        );
      }
    );
  }
} 

class AppBase extends StatelessWidget {
  const AppBase({Key key,}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],

      //home: Welcome(analytics: analytics, observer: observer),
      initialRoute: '/',
      routes: {
        '/': (context) => WalkThrough(),
        '/welcome': (context) => Welcome(analytics: analytics, observer: observer),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),    
        '/explore': (context) => Explore(), 
        '/feed_page': (context) => FeedPage(),  
        '/notification_page': (context) => NotificationPage(),   
        '/profile_page': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfile(),   
        '/change_password':  (context) => ChangePassword(),   
        '/edit_post.dart': (context) => EditPost(),
        '/following_followers': (context) => FollowingView()
      },
    );
  }
}

