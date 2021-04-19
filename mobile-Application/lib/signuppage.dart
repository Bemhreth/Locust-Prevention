import 'dart:async';

import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loc_vent/signinpage.dart';

import 'album.dart';
import 'loading.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  LocationData _currentPosition;
  String _address,_dateTime;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final  auth = FirebaseAuth.instance;
  bool passvisibility = true;
  bool _success;
  bool _isLoading=true;
  String _userEmail;
  static const String em = "@locvest.com";
  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(_currentPosition.latitude, _currentPosition.longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }


  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
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

  void _register() async {
    final User user = (await
    auth.createUserWithEmailAndPassword(
      email: _emailController.text+em,
      password: _passwordController.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _success = true;
        _isLoading=false;
      });
    } else {
      setState(() {
        _success = true;
        _isLoading=false;
      });
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    Future<Album> _futureAlbum;
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
                    height: height*0.35,
                  ),
                ),
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
                SizedBox(height:height/30,),
                Container(
                  width: width/1.2,
                  height: height/17,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
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
                SizedBox(height:height/30,),
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
                SizedBox(height:height/30,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forget password?',style: TextStyle(fontSize: 12.0),),
                    ],
                  ),
                ),
                SizedBox(height:height/49),
                SizedBox(
                  width: width/2.3,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),
                    ),
//                  shape: ,
                    child: Text('Register',style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          getLoc();
                            _futureAlbum = createAlbum(_emailController.text,_phoneController.text,_currentPosition.latitude.toString(),_currentPosition.longitude.toString());
                            print(_currentPosition.latitude.toString());
                          print(_currentPosition.longitude.toString());
                            _register();
                          _isLoading? Center(child: CircularProgressIndicator(),): Navigator.push(context, MaterialPageRoute(builder: (context)=>Myapp()));
//                          _handleSignup(context);
                        });
                      }else{
                        print("Not Validated");
                      }
                    },
                  ),
                ),
            SizedBox(height:height/39),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Myapp()));
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                        text: 'Already have an account',
                        children: [
                          TextSpan(
                            text: ' Login',
                            style: TextStyle(
                                color: Colors.green
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                SizedBox(height:height/90),
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
  Future<void> _handleSignup(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
      await auth.createUserWithEmailAndPassword(
        email: _emailController.text+em,
        password: _passwordController.text,
      );
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Myapp()));
    } catch (error) {
      print(error);
    }
  }
}