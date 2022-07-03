import 'package:cs310_project_s2/services/analytics.dart';
import 'package:cs310_project_s2/services/crashlytics.dart';
import 'package:cs310_project_s2/userAdd.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

UserAdd _userAdd = UserAdd();
FirebaseAuth auth = FirebaseAuth.instance;

class Welcome extends StatefulWidget {
  const Welcome({Key key, this.analytics, this.observer}) : super(key: key);
  
  final FirebaseAnalytics analytics; 
  final FirebaseAnalyticsObserver observer;



  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  String uid ;
  String username ;
  String email           ;
  String pp;

  @override
  void initState() {
    super.initState();

    enableCrashlytics();

    setCurrentScreen(widget.analytics, widget.observer, 'Home Page', 'HomePageState');
    crashlytics.setUserIdentifier('anonymous');
    crashlytics.setCustomKey('isLoggedIn', false);
    crashlytics.setCustomKey('userID', 26987);
    crashlytics.setCustomKey('isPremiumMember', true);
  }

  Future<void> _setCurrentScreen() async {
    await setCurrentScreen(widget.analytics, widget.observer, 'Welcome Page', 'WelcomePageState');
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
//        centerTitle: true,
//        backgroundColor: AppColors.headingColor,

      //  title: Text("Welcome Page",
      //  style: TextStyle(
      //    color: AppColors.headingColor
      //  ),)
      //),
      backgroundColor: AppColors.primary,

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://st4.depositphotos.com/5303366/40222/v/600/depositphotos_402229138-stock-video-fantastical-festive-blue-bg-stylish.jpg"),
            //image: NetworkImage("https://img.freepik.com/free-vector/brick-wall-with-spot-lights-background-style_23-2148639921.jpg?size=626&ext=jpg"),
            //image: NetworkImage("https://marketplace.canva.com/EAD290lurNo/2/0/400w/canva-rainbow-gradient-dark-violet-zoom-virtual-background-xJBQAGJ8sl4.jpg"),
            //image: NetworkImage("https://marketplace.canva.com/EAEUVDE1V3Q/3/0/800w/canva-gradient-zoom-virtual-background-YatLSBjo9sc.jpg"),
            //image: NetworkImage("https://images-ext-1.discordapp.net/external/v3kk7zuyn7e-kc-TOn-TFMXLzEVQFIMoESZkNH5q5QI/%3Fu%3Dhttp%253A%252F%252Fimages.freecreatives.com%252Fwp-content%252Fuploads%252F2016%252F02%252FLight-Aqua-Blue-Background-Free-Download.jpg%26f%3D1%26nofb%3D1/https/external-content.duckduckgo.com/iu/?width=800&height=600"),

              fit: BoxFit.cover
      
          )
        ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                Text("Welcome",
                style: TextStyle(
                  fontSize: 48,
                  color: AppColors.welcomeTextColor
                ),),

                SizedBox(height: 80,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    OutlinedButton(
                      onPressed: (){Navigator.pushNamed(context, "/login");},
                      child:  
                      Text(
                        "  Login  ",
                        style: TextStyle(
                          color: AppColors.welcomeTextColor,
                          fontSize: 18
                        ),
                      ),


                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.welcomeMainColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 30,),



                    OutlinedButton(
                      onPressed: (){ Navigator.pushNamed(context, "/signup");},
                      child:  Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.welcomeTextColor,
                          fontSize: 18
                        ),
                      ),
                      
                      
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.welcomeMainColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              
                            ),
                          ),
                        ),
                    )
                  ],

                ),
                SizedBox(height: 30,),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    bool valid = true;
                    try {
                      UserCredential userCredential = await signInWithGoogle();
                      uid = userCredential.user.uid;
                      username = userCredential.user.displayName;
                      email = userCredential.user.email;   
                      pp =  userCredential.user.photoURL;         
                    } catch(error){
                      valid = false;
                      print(error.toString());
                      if (error.code == 'sign-in-failed')
                      {
                        print('Sign in failed in google login');
                      }
                      //Navigator.pushNamed(context, '/feed_page');

                    }
                    if(valid) {

                      _userAdd.addGoogleUser(uid, username, email, pp);
                      Navigator.pushNamed(context, '/feed_page');
                    }
                  },
                ),
              ],

            ),
      )
    );
  }
}