import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? secilensehir;
  final myController = TextEditingController();

// user defined function
  // ignore: unused_element
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("HATA"),
          content: Text("Geçersiz Bir Şehir Girdiniz"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/search.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: myController,
                // onChanged: (value){
                //   secilensehir=value;
                //   // ignore: avoid_print
                //   print(secilensehir);
                // },
                decoration: InputDecoration(
                    hintText: 'Şehir Seçiniz',
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () async {
                var response = await http.get(Uri.parse(
                    'https://www.metaweather.com/api/location/search/?query=${myController.text}'));
                jsonDecode(response.body).isEmpty
                    ? _showDialog()
                    : Navigator.pop(context, myController.text);
              },
              child: Text('Şehri Seç'),
            ),
          ],
        ),
      ),
    );
  }
}
