import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutturkazan/s%C3%BCperloto.dart';
import 'package:uuid/uuid.dart';

class ParaYatirmaSayfasi extends StatefulWidget {
  @override
  _ParaYatirmaSayfasiState createState() => _ParaYatirmaSayfasiState();
}
   int bakiye = 0;
   int paraMiktari = 0;


class _ParaYatirmaSayfasiState extends State<ParaYatirmaSayfasi> {



  // Kullanıcının bakiyesini güncelle
  Future<void> bakiyeyiGetir() async {
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await firestore.collection('kullanicilar').doc(userId).get();
      if (snapshot.exists) {
        setState(() {
          bakiye = (snapshot.data() as Map<String, dynamic>)['bakiye'] ?? 0;
        });
      }
    }
  }


  User? user;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUser();
    bakiyeyiGetir(); // İlk başta bakiyeyi getir
    paraMiktari = 0; // Para miktarını sıfırla
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      user = currentUser;
      userId = currentUser?.uid;
    });
  }

  Future<void> paraYatir() async {
    try {
      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference docRef = firestore.collection('kullanicilar').doc(userId);

        firestore.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(docRef);

          if (snapshot.exists) {
            int bakiyeSnapshot = (snapshot.data() as Map<String, dynamic>)['bakiye'] ?? 0;
            int yeniBakiye = bakiyeSnapshot + paraMiktari;

            transaction.update(docRef, {'bakiye': yeniBakiye});
            setState(() {
              bakiye = yeniBakiye;
            });
          } else {
            int yeniBakiye = paraMiktari;

            transaction.set(docRef, {'bakiye': yeniBakiye});
            setState(() {
              bakiye = yeniBakiye ;
            });
          }
        });


        // Geri bildirim gösterme
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Başarılı'),
              content: Text('Para yatırma işlemi tamamlandı.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Hata durumunda geri bildirim gösterme
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Para yatırma işlemi sırasında bir hata oluştu: $e'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Para Yatır', style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Mevcut Bakiye:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$bakiye', // Bakiye değerini ekranda göster
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Yatırmak istediğiniz para miktarını girin:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  paraMiktari = double.tryParse(value)?.toInt() ?? 0;
                });
              },

              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(130, 40),
                primary: Colors.white,
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                await paraYatir();
              },
              child: Text(
                "Para Yatır",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(130, 40),
                backgroundColor: Colors.white,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuperLotoApp(),
                  ),
                );
              },
              child: Text(
                "Süper Loto",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}