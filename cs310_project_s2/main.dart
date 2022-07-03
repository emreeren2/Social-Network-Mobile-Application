/*import 'package:cs310_week11_app/routes/homePage.dart';
import 'package:cs310_week11_app/routes/login.dart';
import 'package:cs310_week11_app/routes/unknownWelcome.dart';
import 'package:cs310_week11_app/routes/welcome.dart';
import 'package:cs310_week11_app/routes/welcomeNoFirebase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'routes/welcome.dart';

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
            home: WelcomeViewNoFB(),
          );
        }
        if(snapshot.connectionState == ConnectionState.done) {
          print('Firebase connected');
          return AppBase();
        }

        return MaterialApp(
          home: UnknownWelcome(),
        );
      }
    );
  }
}

class AppBase extends StatelessWidget {
  const AppBase({
    Key key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildConte/xt context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      home: HomePage(analytics: analytics, observer: observer),
      routes: {
        '/login': (context) => Login(),
      },
    );
  }
}
*/