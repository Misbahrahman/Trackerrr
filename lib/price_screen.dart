import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Future<dynamic> get_data(String selected_Currency, String crypto) async {
    Response response = await get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$crypto/$selected_Currency?apikey=BA514898-4C51-42C6-A44F-C0DC7DFC38F7'));
    var data = response.body;
    var usd_value = jsonDecode(data)['rate'];
    //print(usd_value);
    if (response.statusCode == 200) {
      return usd_value.toInt();
    } else {
      return 'ERROR';
    }
  }

  String currency_chosen = 'USD';

  var Value_BTC;
  var Value_ETH;
  var Value_LTH;

  void data() async {
    Value_BTC = await get_data(selected_currency, 'BTC');
    Value_ETH = await get_data(selected_currency, 'ETH');
    Value_LTH = await get_data(selected_currency, 'LTH');
  }

  CupertinoPicker get_picker() {
    List<Text> list_ = [];
    List<String> list1_ = [];
    for (String cur in currenciesList) {
      list_.add(Text(cur));
      list1_.add(cur);
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selected_currency = list1_[selectedIndex].toString();
          });
        },
        children: list_);
  }

  DropdownButton get_button() {
    List<DropdownMenuItem<String>> drop_down_items = [];
    for (String i in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(i),
        value: i,
      );
      drop_down_items.add(item);
    }

    return DropdownButton<String>(
      value: selected_currency,
      items: drop_down_items,
      onChanged: (value) {
        setState(
          () {
            selected_currency = value.toString();
          },
        );
      },
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return get_button();
    } else if (Platform.isIOS) {
      return get_picker();
    } else {
      return get_picker();
    }
  }

  String selected_currency = 'USD';

  @override
  Widget build(BuildContext context) {
    data();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('T r a c k e r r r',style:TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                card_(Value_: Value_BTC, selected_currency: selected_currency,coin: 'BTC',),
                card_(Value_: Value_ETH, selected_currency: selected_currency,coin:'ETC'),
                card_(Value_: Value_LTH, selected_currency: selected_currency,coin: 'LTH',)
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black26,
            child: get_picker(),
          ),
        ],
      ),
    );
  }
}

class card_ extends StatelessWidget {
  card_({
    Key? key,
    required this.Value_,
    required this.selected_currency,
    required this.coin,
  }) : super(key: key);

  var Value_;
  final String selected_currency;
  String coin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(

        color: Colors.red,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${coin} = ${Value_} ${selected_currency} ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),

      ),
    );
  }
}
