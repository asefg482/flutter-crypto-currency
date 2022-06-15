import 'package:crypto_app/Data/Constant/Constant.dart';
import 'package:crypto_app/Data/Model/Coin.dart';
import 'package:crypto_app/Pages/Crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color_Black_Color,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Color_Green_Color,
              size: 70,
            ),
          ],
        ),
      ),
    );
  }

  void Get_Data() async {
    var Response_Data = await Dio().get('https://api.coincap.io/v2/assets');
    List<Coin> Coin_List = Response_Data.data['data']
        .map<Coin>((Json_Map_Object) => Coin.From_Map_Json(Json_Map_Object))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Crypto(
          Coin_List: Coin_List,
        ),
      ),
    );
  }
}
