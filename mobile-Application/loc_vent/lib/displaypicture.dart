import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loc_vent/resultpage.dart';
import 'package:path/path.dart';


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String name;

  const DisplayPictureScreen({Key key, this.imagePath, this.name}) : super(key: key);

  upload(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://34.71.91.164/uploadfile");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path)
    );

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);
String res;
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      res=value;
    });
    return res;
  }
  @override
  Widget build(BuildContext context) {
    String result1;
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('The Picture you took'),
      backgroundColor: Colors.green,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: Image.file(File(imagePath))),
            Expanded(
              flex: 1,
              child: ButtonTheme(
                minWidth: width/1.2,
                height: height/2,
                child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),
                ),
//                  shape: ,
                child: Text('Submit Image',style: TextStyle(color: Colors.white),),
                color: Colors.blueGrey,
                onPressed: () async {
                  File imageFile = File(imagePath);
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  // open a bytestream
                  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
                  // get file length
                  var length = await imageFile.length();

                  // string to uri
                  var uri = Uri.parse("http://34.71.91.164/uploadfile");

                  // create multipart request
                  var request = new http.MultipartRequest("POST", uri);

                  // multipart that takes file
                  var multipartFile = new http.MultipartFile('file', stream, length,
                      filename: basename(imageFile.path)
                  );

                  // add file to multipart
                  request.files.add(multipartFile);

                  // send
                  var response = await request.send();
                  print(response.statusCode);
                  String res;
                  // listen for response
                  response.stream.transform(utf8.decoder).listen((value) {
                    print(value);
                    res=value;
                  });
                  result1=res;
//                  result1=upload(File(imagePath)).toString();
                  await http.MultipartRequest("POST", Uri.parse("http://34.71.91.164/uploadfile")).send();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(res:result1),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height:height/28,),
          ],
        ),
      ),
      backgroundColor: Colors.green,
    );
  }
}