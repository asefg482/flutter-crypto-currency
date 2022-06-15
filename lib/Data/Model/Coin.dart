class Coin {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Coin(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );


  factory Coin.From_Map_Json(Map<String,dynamic> Json_Map_Object) {
    return Coin(
      Json_Map_Object['id'],
      Json_Map_Object['name'],
      Json_Map_Object['symbol'],
      double.parse(Json_Map_Object['changePercent24Hr']),
      double.parse(Json_Map_Object['priceUsd']),
      double.parse(Json_Map_Object['marketCapUsd']),
      int.parse(Json_Map_Object['rank'])
    );
  }
}
