import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutturkazan/sonuc.dart';

class TutarGirScreen extends StatefulWidget {
  TutarGirScreen({Key? key, required this.girilensayilar}) : super(key: key);
  List<int> girilensayilar = [];

  @override
  _TutarGirScreenState createState() => _TutarGirScreenState();
}

int tutar = 0;
List<int> selectedNumbers = [];
List<int> winningNumbers = [];
bool hasWon = false;
late int matchingNumbers = 0;
int bakiye = 0;

class _TutarGirScreenState extends State<TutarGirScreen> {
  TextEditingController tutarcontroller = TextEditingController();

  Future<void> bakiyeyiGetir() async {
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot =
          await firestore.collection('kullanicilar').doc(userId).get();
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
    bakiyeyiGetir();
  }

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      user = currentUser;
      userId = currentUser?.uid;
    });
  }

  void checkWinningNumbers() {
    matchingNumbers = 0;
    for (int number in widget.girilensayilar) {
      if (winningNumbers.contains(number)) {
        matchingNumbers++;
      }
    }

    if (matchingNumbers == 6) {
      setState(() {
        hasWon = true;
        bakiye += tutar * 50;
      });
    } else if (matchingNumbers == 5) {
      setState(() {
        bakiye += tutar * 7;
      });
    } else if (matchingNumbers == 4) {
      setState(() {
        bakiye += tutar * 5;
      });
    } else if (matchingNumbers == 3) {
      setState(() {
        bakiye += tutar * 3;
      });
    } else if (matchingNumbers == 2) {
      setState(() {
        bakiye += tutar;
      });
    }

    // Veritabanına bakiyeyi kaydet
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('kullanicilar')
          .doc(userId)
          .set({'bakiye': bakiye}, SetOptions(merge: true)).then((value) {
        print('Bakiye güncellendi ve veritabanına kaydedildi.');
      }).catchError((error) {
        print('Bakiye güncellenirken bir hata oluştu: $error');
      });
    }
    print(matchingNumbers);
  }

  void generateWinningNumbers() {
    setState(() {
      winningNumbers = [];
      var random = Random();
      while (winningNumbers.length < 6) {
        int number = random.nextInt(60) + 1;
        if (!winningNumbers.contains(number)) {
          winningNumbers.add(number);
        }
      }
      print(winningNumbers);
    });
  }

  bool checkWin() {
    for (int number in selectedNumbers) {
      if (winningNumbers.contains(number)) {
        matchingNumbers++;
      }
    }
    return matchingNumbers == 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Tutar Gir',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.girilensayilar.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              ),
              TextField(
                controller: tutarcontroller,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    tutar = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Tutar',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (bakiye != null) {
                    if (tutar <= bakiye!) {
                      int updatedBalance =
                          bakiye! - int.parse(tutarcontroller.text);
                      FirebaseFirestore.instance
                          .collection('kullanicilar')
                          .doc(userId)
                          .update({'bakiye': updatedBalance}).then((value) {
                        setState(() {
                          bakiye = updatedBalance;
                        });
                        generateWinningNumbers();
                        checkWinningNumbers();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sonuc(
                              secilensayilar: winningNumbers,
                              aynisayilar: matchingNumbers,
                              girilensayilar: widget.girilensayilar,
                            ),
                          ),
                        );
                      }).catchError((error) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Hata'),
                              content: Text(
                                  'Bakiye güncellenirken bir hata oluştu.'),
                              actions: [
                                TextButton(
                                  child: Text('Tamam'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => sonuc(
                                            secilensayilar: winningNumbers,
                                            aynisayilar: matchingNumbers,
                                            girilensayilar: selectedNumbers,
                                          ),
                                        ));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Hata'),
                            content: Text('Yetersiz bakiye'),
                            actions: [
                              TextButton(
                                child: Text('Tamam'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Hata'),
                          content: Text('Bakiye bilgisi bulunamadı.'),
                          actions: [
                            TextButton(
                              child: Text('Tamam'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Onayla',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
