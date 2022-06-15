import 'package:crypto_app/Data/Constant/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/Data/Model/Coin.dart';

class Crypto extends StatefulWidget {
  Crypto({Key? key, this.Coin_List}) : super(key: key);

  List<Coin>? Coin_List;

  @override
  _CryptoState createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {
  List<Coin>? Coin_List_Data;
  bool Is_Search_Loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Coin_List_Data = widget.Coin_List;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color_Black_Color,
        appBar: AppBar(
          backgroundColor: Color_Black_Color,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Crypto",
            style: TextStyle(
              color: Color_Green_Color,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextField(
                  onChanged: (Value) async {
                    Filter_List(Value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search . . .",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Color_Black_Color,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color_Green_Color),
                ),
              ),
              Visibility(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Updating Coins Data . . .",
                      style: TextStyle(color: Color_Green_Color),
                    ),
                  ],
                ),
                visible: Is_Search_Loading,
              ),
              Expanded(
                child: Visibility(
                  visible: !Is_Search_Loading,
                  child: RefreshIndicator(
                    backgroundColor: Color_Green_Color,
                    color: Color_Black_Color,
                    child: ListView.builder(
                      itemCount: Coin_List_Data!.length,
                      itemBuilder: (context, index) => ListTile(
                        tileColor: Color_Black_Color,
                        title: Text(
                          Coin_List_Data![index].name,
                          style: TextStyle(color: Color_Green_Color),
                        ),
                        subtitle: Text(
                          Coin_List_Data![index].symbol,
                          style: TextStyle(color: Color_Gray_Color),
                        ),
                        leading: Get_Rank(index),
                        trailing: Get_Trail(index),
                      ),
                    ),
                    onRefresh: () async {
                      List<Coin> Refreshed_Data = await Get_Data();
                      setState(() {
                        Coin_List_Data = Refreshed_Data;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Coin>> Get_Data() async {
    var Response_Data = await Dio().get('https://api.coincap.io/v2/assets');
    List<Coin> Coin_List = Response_Data.data['data']
        .map<Coin>((Json_Map_Object) => Coin.From_Map_Json(Json_Map_Object))
        .toList();
    return Coin_List;
  }

  Widget Get_Icon(int index) {
    return Icon(
      Coin_List_Data![index].changePercent24hr >= 0
          ? Icons.trending_down
          : Icons.trending_up,
      color: Coin_List_Data![index].changePercent24hr >= 0
          ? Colors.red
          : Colors.green,
    );
  }

  Widget Get_Rank(int index) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          Coin_List_Data![index].rank.toString(),
          style: TextStyle(color: Colors.lightGreenAccent),
        ),
      ),
    );
  }

  Widget Get_Trail(int index) {
    return SizedBox(
      width: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$" + Coin_List_Data![index].priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
                Text(
                  Coin_List_Data![index].changePercent24hr >= 0
                      ? "+" +
                          Coin_List_Data![index]
                              .changePercent24hr
                              .toStringAsFixed(2) +
                          "%"
                      : Coin_List_Data![index]
                              .changePercent24hr
                              .toStringAsFixed(2) +
                          "%",
                  style: TextStyle(
                    color: Coin_List_Data![index].changePercent24hr >= 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            Get_Icon(index),
          ],
        ),
      ),
    );
  }

  Future<void> Filter_List(String Search_Data) async {
    List<Coin> Coin_Result = [];
    if (Search_Data.isEmpty) {
      setState(() {
        Is_Search_Loading = true;
      });
      var Result = await Get_Data();
      setState(() {
        Coin_List_Data = Result;
        Is_Search_Loading = false;
      });
      return;
    } else {
      Coin_Result = Coin_List_Data!.where((element) {
        return element.name.toLowerCase().contains(Search_Data.toLowerCase());
      }).toList();
      setState(() {
        Coin_List_Data = Coin_Result;
      });
      return;
    }
  }
}
