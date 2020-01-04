// import 'package:flutter/material.dart';

// Future<File> profileImg;

// @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: AppBar(
//           title: Text("Gallery Image Picker"),
//         ),
//         body: profilePic());
//   }

// Widget profilePic() {
//     return ListView(children: <Widget>[
//       FutureBuilder(
//         builder: (context, data) {
//           if (data.hasData) {
//             return Container(
//               height: 200.0,
//               child: Image.file(
//                 data.data,
//                 fit: BoxFit.contain,
//                 height: 200.0,
//               ),
//               color: Colors.blue,
//             );
//           }
//           return Container(
//             height: 200.0,
//             child: Image.network('https://via.placeholder.com/150'),
//             color: Colors.blue,
//           );
//         },
//         future: profileImg,
//       ),
//       RaisedButton(
//         color: Colors.blue,
//         onPressed: () {
//           profileImg = ImagePicker.pickImage(source: ImageSource.gallery)
//               .whenComplete(() {
//             setState(() {});
//           });
//         },
//         child: new Text(
//           "Pick Gallery Image",
//           style: TextStyle(fontSize: 20.0, color: Colors.white),
//         ),
//       ),
//     ]);
//   }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyHomePage());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Color(0xFFFEF9EB),
      ),
      title: "Toko Sepatu",
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
