import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loc_vent/signinpage.dart';

//2

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//3
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Myapp(),
    );
  }
}
