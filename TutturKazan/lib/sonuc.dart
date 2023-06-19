import 'package:flutter/material.dart';

class sonuc extends StatefulWidget {
  sonuc({Key? key, required this.secilensayilar, required this.aynisayilar, required this.girilensayilar}) : super(key: key);
  List<int> secilensayilar = [];
  int aynisayilar ;
  List <int> girilensayilar = [];

  @override
  State<sonuc> createState() => _sonucState();
}

class _sonucState extends State<sonuc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Sonuç',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Seçtiğiniz Sayilar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),SizedBox(height: 8),
          Text(
            widget.girilensayilar.toString(),
            style: TextStyle(fontSize: 16),
          ),SizedBox(height: 16),
          Text(
            'Sistemin seçtiği sayilar:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            widget.secilensayilar.toString(),
            style: TextStyle(fontSize: 16),
          ),SizedBox(height: 16),
          Text(
            'Ayni olan  sayilar:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ), SizedBox(height: 8),
          Text(
            widget.aynisayilar.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
