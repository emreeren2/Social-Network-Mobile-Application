import 'package:cs310_project_s2/services/analytics.dart';
import 'package:cs310_project_s2/userAdd.dart';
import 'package:cs310_project_s2/utils/color.dart';
import 'package:cs310_project_s2/utils/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  @override
  void initState() {
    super.initState();
    

    setCurrentScreen(widget.analytics, widget.observer, 'SignUp Page', 'SignUpPageState');
  }
  UserAdd _userAdd = UserAdd();
  int attemptCount;
  String mail;
  String pass;
  String pass2;
  String userName;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;



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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'SIGNUP',
          //style: kAppBarTitleTextStyle,
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
                              //labelText: 'Username',
                              //labelStyle: kLabelLightTextStyle,
                              
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
                          height: 40,
                          child: TextFormField(
                            cursorColor: AppColors.primary,   
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              fillColor: AppColors.boxTransparent,
                              filled: true,
                              hintText: 'Username',
                              //labelText: 'Username',
                              //labelStyle: kLabelLightTextStyle,
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

                            validator: (value) {
                              if(value.isEmpty) {
                                return 'Please enter your e-mail';
                              }
                              if(value.length < 4) {
                                return 'Username is too short';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              userName = value;
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
                              hintText: 'Password',
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
                              pass = value;
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
                              hintText: 'Password (Repeat)',
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

                          if(_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            if(pass != pass2) {
                              showAlertDialog("Error", 'Passwords must match');
                            }
                            else {
                              //TODO: Sign up process
                              try{
                                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: mail,
                                    password: pass
                                );
                                String uid = userCredential.user.uid;
                                _userAdd.addUser(uid, userName, mail, pass);
                              }
                              on FirebaseAuthException catch (e) {
                                valid = false;
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  showAlertDialog("Error", "Password is too weak");
                                } else if (e.code == 'email-already-in-use') {
                                  print('The account already exists for that email.');
                                  showAlertDialog("Error", "E-mail already exists");
                                }
                                valid = false;
                              } catch (e) {
                                print(e);
                              }
                              if(valid) {
                                Navigator.pushReplacementNamed(context, '/explore'); //pushNamed
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

                        },

                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Signup',
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
