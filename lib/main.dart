import 'package:crypto_app/Pages/Loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Applicaiton());
}

class Applicaiton extends StatefulWidget {
  const Applicaiton({Key? key}) : super(key: key);

  @override
  _ApplicaitonState createState() => _ApplicaitonState();
}

class _ApplicaitonState extends State<Applicaiton> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
