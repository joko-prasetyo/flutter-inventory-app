import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(MyApp());

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
      home: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Store(),
      ),
    );
  }
}

class Store extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
