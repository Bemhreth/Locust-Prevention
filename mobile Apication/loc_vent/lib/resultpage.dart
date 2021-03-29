import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cameraread.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height:height/5,),
          Center(
            child: Container(
              width: width/1.1,
              height: height/2,
              child: Card(
                elevation: 5,
                 child:Center(child: Text('Result')),
              ),
              decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          ),
          SizedBox(height:height/20,),
          ButtonTheme(
            minWidth: width/1.2,
            height: height/12,
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),
                ),
//                  shape: ,
                child: Text('Ok I understand',style: TextStyle(color: Colors.white),),
                color: Colors.blueGrey,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CamPage(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}