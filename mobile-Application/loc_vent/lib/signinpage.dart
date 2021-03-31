import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loc_vent/signuppage.dart';

import 'cameraread.dart';
import 'loading.dart';

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String userName;
  bool _success;
  bool passvisibility = true;
  String _userEmail;
  final  auth = FirebaseAuth.instance;
  static const String em ="@locvest.com";
  String validatePassword(String value){
    if (value.isEmpty) {
      return "* Required";
    }
    else if (value.length < 8) {
      return "Password should be atleast 8 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    }
    else if ( _success = false){
      return "Wrong Password or Email";
    }
    else
      return null;
  }
  void _signInWithEmailAndPassword() async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text+em,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: Image.asset('assets/locust.jpg',fit: BoxFit.fill,
                    width: width,
                    height: height*0.45,
                  ),
                ),
                SizedBox(height: height/25,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LocVent',style: TextStyle(fontSize: 50.0,fontFamily: 'WolfsBane',color: Colors.green),

                      ),
                    ],
                  ),
                ),
                SizedBox(height:height/28,),
            Container(
              width: width/1.2,
              height: height/17,
              child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      prefixIcon: Icon(Icons.person_pin),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: new BorderSide(color: Colors.green)),
                      ),
                     validator: (value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                            },
              ),

                  ),
                SizedBox(height: height/30,),
                Container(
                  width: width/1.2,
                  height: height/17,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: passvisibility,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: passvisibility?Icon(Icons.visibility_off):Icon(Icons.visibility),
                        onTap: (){
                          setState(() {
                            if(passvisibility)
                            passvisibility = false;
                            else
                              passvisibility = true;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: validatePassword,
                  ),
                ),
                SizedBox(height: height/30,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forget password?',style: TextStyle(fontSize: 12.0),),
                    ],
                  ),
                ),
                SizedBox(height:height/30),
                SizedBox(
                  width: width/2.3,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),
                      ),
//                  shape: ,
                    child: Text('Login',style: TextStyle(color: Colors.white)),
                    color: Colors.green,
                    onPressed: () async {
                      userName=_emailController.text;
                      if (_formKey.currentState.validate()) {
                        setState(() async {
                          _signInWithEmailAndPassword();
//                          _handleSignin(context);
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          if (await FirebaseAuth.instance.currentUser != null)
                          {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CamPage(title:userName,)));
                          }
                          else{
                            try{
                              Navigator.of(context).pop();
                              return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text("You have entered the wrong password or username"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("ok"),
                                    ),
                                  ],
                                ),
                              );
                            }catch(error){
                              print('hello');
                            }

                          }
                        });
                      }else{
                        print("Not Validated");
                      }
                    },
                  ),
                ),
                SizedBox(height:height/29),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Second()));
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                        text: 'Don\'t have an account',
                        children: [
                          TextSpan(
                            text: ' Register',
                            style: TextStyle(
                                color: Colors.green
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                SizedBox(height:height/35),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('LocVent © 2021',style: TextStyle(fontSize: 12.0),),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleSignin(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
      if(FirebaseAuth.instance.currentUser?.uid != null) {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Myapp()));
      }
      else
        Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }
}
