import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cameraread.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key key, this.res}) : super(key: key);
  final String res;
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.res+' here you go beginning');
    bool isDangerous=false;
    if(widget.res=='1')
     isDangerous=false;
    else
     isDangerous=true;
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
                 child:isDangerous?Center(child: SizedBox( width: width/1.7,child: Text('The result shows that the type of the locust is dangerous so stay vigilant and do all the necessary precautions and if necessary local authorities will be in touch',style: TextStyle(color: Colors.black,fontSize:23 ,)))):
                 Center(child: SizedBox( width: width/1.7,child: Text('No need to worry this type of locust is a normal one it wont cause any harm',style: TextStyle(color: Colors.black,fontSize:23 ,)))),
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
                  print(widget.res.toString()+"here is ur file");
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
