import 'package:flutter/material.dart';
import 'package:mongodb_loginreg/login.dart';
import 'package:mongodb_loginreg/register.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}