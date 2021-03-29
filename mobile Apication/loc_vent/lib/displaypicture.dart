import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

import 'cameraread.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
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
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
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
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  upload(File(imagePath));

                  showAlertDialog(BuildContext context) {
                    // set up the button
                    Widget okButton = FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CamPage(),
                          ),
                        );
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("My title"),
                      content: Text("This is my message."),
                      actions: [
                        okButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                }),
              ),),
            SizedBox(height:height/28,),
          ],
        ),
      ),
      backgroundColor: Colors.green,
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.send),
//        backgroundColor: Colors.green,
//        // Provide an onPressed callback.
//        onPressed: () async {
//          // Take the Picture in a try / catch block. If anything goes wrong,
//          // catch the error.
//          upload(File(imagePath));
//
//          showAlertDialog(BuildContext context) {
//
//            // set up the button
//            Widget okButton = FlatButton(
//              child: Text("OK"),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) =>CamPage(),
//                  ),
//                );
//              },
//            );
//
//            // set up the AlertDialog
//            AlertDialog alert = AlertDialog(
//              title: Text("My title"),
//              content: Text("This is my message."),
//              actions: [
//                okButton,
//              ],
//            );
//
//            // show the dialog
//            showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return alert;
//              },
//            );
//          }
//
//          // If the picture was taken, display it on a new screen.
//        },
//      ),
    );
  }
}