import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async/async.dart';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loc_vent/signinpage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CamPage extends StatefulWidget {
  CamPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CamPageState createState() => _CamPageState();
}

class _CamPageState extends State<CamPage> {
//4
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;

  var ImagePath;
  @override
  void initState() {
    super.initState();
    _initializeCamera();

  }

  void onCaptureButtonPressed() async {  //on camera button press
//    try {
//
//      final path = join(
//        (await getTemporaryDirectory()).path, //Temporary path
//        '$pageStatus${DateTime.now()}.png',
//      );
//      ImagePath = path;
//      await _controller.takePicture(path); //take photo
//
//      setState(() {
//        showCapturedPhoto = true;
//      });
//    } catch (e) {
//      print(e);
//    }
  }
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    _controller = CameraController(firstCamera,ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }
  final  auth = FirebaseAuth.instance;
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('camera'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
//5
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme
                  .of(context)
                  .buttonColor,
              onPressed: () async {
                final User user = await auth.currentUser;
                if (user == null) {
//6
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await auth.signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Myapp()));
//                Navigator.pushReplacementNamed(context, MaterialPageRoute(builder: (context)=>Myapp()));
                });

              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Transform.scale(
                  scale: _controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller), //cameraPreview
                    ),
                  ));
            } else {
              return Center(
                  child:
                  CircularProgressIndicator()); // Otherwise, display a loading indicator.
            }
          },
        );
      }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Construct the path where the image should be saved using the
              // pattern package.
              final path = join(
                // Store the picture in the temp directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              // Attempt to take a picture and log where it's been saved.
              await _controller.takePicture(path);
//              upload(File(path));

              if (path != null) SnackBar(
                  content: Text('Yay! A SnackBar!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ));
              // If the picture was taken, display it on a new screen.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );
            }  catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    ),
    );
  }
}
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
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        // Provide an onPressed callback.
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
                    builder: (context) =>CamPage(),
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

            // If the picture was taken, display it on a new screen.
        },
      ),
    );
  }
}