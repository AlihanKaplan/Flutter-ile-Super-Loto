import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutturkazan/login.dart';
import 'package:tutturkazan/nas%C4%B1loynan%C4%B1r.dart';
import 'package:tutturkazan/parayatirma.dart';
import 'package:tutturkazan/tutargir.dart';

class SuperLotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Süper Loto',
      theme: ThemeData.dark(),
      home: SuperLotoScreen(),
    );
  }
}
late int matchingNumbers = 0;

class SuperLotoScreen extends StatefulWidget {
  @override
  _SuperLotoScreenState createState() => _SuperLotoScreenState();
}

class _SuperLotoScreenState extends State<SuperLotoScreen> {
  List<int> selectedNumbers = [];
  List<int> winningNumbers = [];
  bool hasWon = false;



  void selectNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < 6) {
        selectedNumbers.add(number);
      }
    });
  }

  void checkWinningNumbers() {
    for (int number in selectedNumbers) {
      if (winningNumbers.contains(number)) {
        matchingNumbers++;
      }
    }
    if (matchingNumbers == 6) {
      setState(() {
        hasWon = true;
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
      checkWinningNumbers();
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

  void cikisyap() async {
    FirebaseAuth auth = FirebaseAuth.instance.currentUser as FirebaseAuth;
    try {
      await auth.signOut();
      // Firestore'dan çıkış yapma işlemlerini burada gerçekleştirin
      print("Çıkış işlemi başarılı.");
    } catch (e) {
      print("Çıkış yaparken bir hata oluştu: $e");
    }
  }


  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Seçilen Sayıları Temizle'),
            onTap: () {
              setState(() {
                selectedNumbers.clear();
              });
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuperLotoApp()));
              },
              child: Text("Süper Loto", style: TextStyle(color: Colors.black),)),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParaYatirmaSayfasi()));
              },
              child: Text("Para Yatırma", style: TextStyle(color: Colors.black),)),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => bilgi()));
              },
              child: Text("Nasıl Oynanır?", style: TextStyle(color: Colors.black),)),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () {
                cikisyap();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GirisPage()));
              },
              child: Text("Çıkış Yap", style: TextStyle(color: Colors.black),)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Süper Loto', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seçtiğiniz Sayılar: $selectedNumbers',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(1),
                      child: Text('1', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(2),
                      child: Text('2', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(3),
                      child: Text('3', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(4),
                      child: Text('4', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(5),
                      child: Text('5', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(6),
                      child: Text('6', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(7),
                      child: Text('7', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(8),
                      child: Text('8', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(9),
                      child: Text('9', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(10),
                      child: Text('10', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(11),
                      child: Text('11', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(12),
                      child: Text('12', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(13),
                      child: Text('13', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(14),
                      child: Text('14', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(15),
                      child: Text('15', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(16),
                      child: Text('16', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(17),
                      child: Text('17', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(18),
                      child: Text('18', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(19),
                      child: Text('19', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(20),
                      child: Text('20', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(21),
                      child: Text('21', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(22),
                      child: Text('22', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(23),
                      child: Text('23', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(24),
                      child: Text('24', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(25),
                      child: Text('25', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(26),
                      child: Text('26', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(27),
                      child: Text('27', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(28),
                      child: Text('28', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(29),
                      child: Text('29', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(30),
                      child: Text('30', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(31),
                      child: Text('31', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(32),
                      child: Text('32', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(33),
                      child: Text('33', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(34),
                      child: Text('34', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(35),
                      child: Text('35', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(36),
                      child: Text('36', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(37),
                      child: Text('37', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(38),
                      child: Text('38', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(39),
                      child: Text('39', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(40),
                      child: Text('40', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(41),
                      child: Text('41', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(42),
                      child: Text('42', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(43),
                      child: Text('43', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(44),
                      child: Text('44', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(45),
                      child: Text('45', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(46),
                      child: Text('46', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(47),
                      child: Text('47', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(48),
                      child: Text('48', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(49),
                      child: Text('49', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(50),
                      child: Text('50', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(51),
                      child: Text('51', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(52),
                      child: Text('52', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(53),
                      child: Text('53', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(54),
                      child: Text('54', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(55),
                      child: Text('55', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(56),
                      child: Text('56', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(57),
                      child: Text('57', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(58),
                      child: Text('58', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(59),
                      child: Text('59', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 27),
                    ElevatedButton(
                      onPressed: () => selectNumber(60),
                      child: Text('60', style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Diğer sayı düğmelerini buraya ekleyin (3, 4, 5, ...)
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutarGirScreen(girilensayilar:selectedNumbers,),
                      ),
                    );
                  },
                  child: Text('Tutar gir', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                if (hasWon)
                  Text(
                    'Tebrikler! Büyük ikramiyeyi kazandınız!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
