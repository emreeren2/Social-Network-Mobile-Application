import 'package:cs310_project_s2/userAdd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:cs310_project_s2/utils/color.dart';
import 'package:cs310_project_s2/utils/styles.dart';




class ChangePassword extends StatefulWidget {
  const ChangePassword({ Key key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  UserAdd _userAdd = UserAdd();
  var user = FirebaseAuth.instance.currentUser;
  String _message = '';
  
  int attemptCount;
  String mail;
  String pass;
  String pass2;
  String pass1;
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;


  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
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


                  SizedBox(height: 12.0,),


                  Column(
                    children: [
                       Container(
                         height: 40.0,
                         child: TextFormField(
                            cursorColor: AppColors.primary,   
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              fillColor: AppColors.boxTransparent,
                              filled: true,
                              hintText: 'New password',
                              //labelText: 'Username',
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
                                return 'Please enter your new password';
                              }
                              if(value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              pass1 = value;
                            },
                          ),
                       ),

                         SizedBox(height: 12.0,),

                        Container(
                          height: 40.0,
                          child: TextFormField(
                            cursorColor: AppColors.primary,   
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              fillColor: AppColors.boxTransparent,
                              filled: true,
                              hintText: 'New password (Repeat)',
                              //labelText: 'Username',
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
                              pass2 = value;
                            },
                          ),
                        ),
                
                    ],
                  ),

                  SizedBox(height: 30,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () async {
                          bool valid = true;

                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: mail,
                                password: pass
                            );
                          } on FirebaseAuthException catch (e) {
                            //valid = false;
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            valid = false;

                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              valid = false;
                            }
                            //valid = false;
                          }
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            if(valid){
                              if(_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                if(pass1 != pass2) {
                                  showAlertDialog("Error", 'Passwords must match');
                                }
                                else {
                                  //TODO: Sign up process
                                  try{
                               
                                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: mail,
                                        password: pass
                                    );
                                    userCredential.user.updatePassword(pass1);                                      
                                    String uid = userCredential.user.uid;
                                    _userAdd.updateUser(uid, pass1);
                                    
                                  }
                                  on FirebaseAuthException catch (e) {
                                    valid = false;
                                    if (e.code == 'weak-password') {
                                      print('The password provided is too weak.');
                                      showAlertDialog("Error", "Password is too weak");
                                    } 
                                    valid = false;
                                  } catch (e) {
                                    print(e);
                                  }
                                  if(valid) {
                                    Navigator.pushReplacementNamed(context, '/feed_page'); //pushNamed
                                  }
                                  else
                                    showAlertDialog("Error", "Email is invalid or already exists");
                                }
                                //
                                setState(() {
                                  attemptCount += 1;
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Logging in')));
                              }
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
                            'Change and Login',
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

class GoogleSignIn {
}