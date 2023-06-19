import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutturkazan/kay%C4%B1tol.dart';
import 'package:tutturkazan/login.dart';
import 'package:tutturkazan/s%C3%BCperloto.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class GirisPage extends StatefulWidget {
  const GirisPage({Key? key}) : super(key: key);

  @override
  State<GirisPage> createState() => _GirisPageState();
}

class _GirisPageState extends State<GirisPage> {
  final _formKey = GlobalKey<FormState>();

  late String _password;
  late String _email;

  Future<void> _login() async {
    print("sifre girmedi");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("girdi");
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        if (userCredential.user != null) {
          // kullanıcının kimliğini kaydet
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('user_id',_auth.currentUser!.uid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SuperLotoApp()));

        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: "gmail veya şifre yanlış");

          print('Kullanıcı bulunamadı.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: "gmail veya şifre yanlış");
        }
      } catch (e) {
        print(e);
      }
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
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KayitScreen()),
                );
              },
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
                  backgroundColor: Colors.green,
                ),
                onPressed: () {},
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
                      "Giriş Yap",
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Bu uygulama çok güzel"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email giriniz",
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email giriniz';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          hintText: "Şifre giriniz",
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre giriniz';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text("Giriş"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}