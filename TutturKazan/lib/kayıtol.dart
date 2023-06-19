import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutturkazan/login.dart';
import 'package:tutturkazan/parayatirma.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class KayitScreen extends StatefulWidget {
  const KayitScreen({Key? key}) : super(key: key);

  @override
  State<KayitScreen> createState() => _KayitScreenState();
}

User? user = FirebaseAuth.instance.currentUser;


class _KayitScreenState extends State<KayitScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _password;
  late String _email;


  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {

        UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        String userId = userCredential.user?.uid ?? '';
        var database =
        await FirebaseFirestore.instance.collection("kullanicilar").doc(userId);
        database.set({
          'bakiye': 0,
          'email': _email,
          'sifre': _password,
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GirisPage(),
          ),
        );

        // Kullanıcı başarılı bir şekilde kaydedildi
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Güçsüz parola.');
        } else if (e.code == 'email-already-in-use') {
          print('Bu e-posta zaten kullanılıyor.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // E-posta doğrulama e-postasını gönderin
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      print('E-posta doğrulama hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {},
              child: Center(
                child: Text(
                  "kayıt ol",
                  style: TextStyle(color: Colors.black),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => GirisPage()));
                },
                child: Center(
                  child: Text(
                    "giriş yap",
                    style: TextStyle(color: Colors.black),
                  ),
                )),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(children: [
            Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Kayıt ol",
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Bu uygulama bir harika dostum!"),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              label: Text("email")),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen bir email girin.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                            if (!_email.contains('@')) {
                              _email += '@gmail.com';
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              label: Text("sifre")),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen bir sifre girin.';
                            } else if (value.length < 6) {
                              return 'Parola en az 6 karakter olmalıdır.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          }),
                    ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: (){
                          setState(() {
                            _register();
                          });
                        },
                        child: Text("Kayıt Ol"))
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GirisPage(),
                    ),
                  );
                },
                child: Text(
                  "zaten hesabım var",
                  style: TextStyle(fontSize: 18),
                ))
          ]),
        ),
      ),
    );
  }
}