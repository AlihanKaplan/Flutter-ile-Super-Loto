import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutturkazan/s%C3%BCperloto.dart';

class bilgi extends StatefulWidget {
  const bilgi({Key? key}) : super(key: key);

  @override
  State<bilgi> createState() => _bilgiState();
}

class _bilgiState extends State<bilgi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nasıl Oynanır?', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Column(
          children: [
            Text(
              'Oyunda 6 tane kolon vardir. Oynayacak kisi her kolona (1-60) arasi birbirinden farkli sayilari girmektedir. Sayilar girildikten sonra bilgisayar kendi 6 kolon sayisini yazar. Kazanmak icin min. 2 tane maks. 6 tane sayi bilmek gerekiyor.0 veya 1 dogru tahminde para kazanamazsiniz. 2 dogru tahminde yatirdiginiz paranin 1 kati, 3 dogru tahminde 3 kati, 4 dogru tahminde 5 kati, 5 dogru tahminde 7 kati, 6 dogru tahminde 50 kati para kazanirsiniz.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)) ,

                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SuperLotoApp()));
                },
                child: Text("Süper Loto", style: TextStyle(color: Colors.black),)),
          ],
        )),
      ),
    );
  }
}
