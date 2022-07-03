import 'package:firebase_core/firebase_core.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:cs310_project_s2/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _message = '';
  
  int attemptCount;
  String mail;
  String pass;
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;


  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
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
    UserCredential userCredential = await auth.signInWithCredential(credential);
    print(userCredential.toString());
    return userCredential;
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: mail,
          password: pass
      );
      print(userCredential.toString());

    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'wrong-password') {
        setmessage('Please check your password');
      }
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  
  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User user) {
      if(user == null) {
        print('User is signed out');
      }
      else {
        print('User is signed in');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    print('Build called');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: regularButtonText,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 40.0,
                          child: TextFormField(   
                            cursorColor: AppColors.primary,      
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              fillColor: AppColors.boxTransparent,
                              filled: true,
                              hintText: 'E-mail',
                           
                              labelStyle: regularText,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(width: 2,color: AppColors.primary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(width: 1,color: AppColors.primary),
                              ),     
                            ),
                            keyboardType: TextInputType.emailAddress,

                            validator: (value) {
                              if(value.isEmpty) {
                                return 'Please enter your e-mail';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              mail = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.0,),


                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 40.0,
                          child: TextFormField(
                            cursorColor: AppColors.primary,                               
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              fillColor: AppColors.boxTransparent,
                              filled: true,
                              hintText: 'Password',

                              labelStyle: regularText,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(width: 2,color: AppColors.primary),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                borderSide: BorderSide(width: 1,color: AppColors.primary),
                              ),     
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,

                            validator: (value) {
                              if(value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if(value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              pass = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12,),   

                  GestureDetector(
                    child: Text("change my password", style: TextStyle(decoration: TextDecoration.underline, color: AppColors.red)),
                    onTap: () {Navigator.pushReplacementNamed(context, '/change_password');} // changing password procedure               
                  ),              

                  SizedBox(height: 30,),


                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
 
                      OutlinedButton(
                        
                        onPressed: () async {
                          bool valid = true;

                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: mail,
                                password: pass
                            );
                            valid =true;
                          } on FirebaseAuthException catch (e) {
                            valid = false;
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            valid = false;

                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              valid = false;
                            }
                            valid = false;
                          }
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            print(valid.toString());
                            if(valid){
                              Navigator.pushReplacementNamed(context, '/feed_page'); //TODO burasi degisti
                              setState(() {
                               attemptCount += 1;
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Logging in')));
                          }
                            else{
                              showAlertDialog("Error", "Invalid email or password");
                            }
                          }

                        },

                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Login',
                            style: regularButtonText,
                          ),
                        ),
                       
                        
                        style: ButtonStyle(  
                          minimumSize: MaterialStateProperty.all(Size(120, 40)),          
                          backgroundColor: MaterialStateProperty.all(AppColors.primary),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                                                      
                            ),
                          ),
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
    );
  }
}
