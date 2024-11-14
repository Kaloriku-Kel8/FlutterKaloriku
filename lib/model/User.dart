import 'dart:convert';
import 'dart:io';
import 'package:kaloriku/model/User.dart';
import 'package:http/http.dart' as http;

class User {
  String email;
  String password;
  String confirmPassword;

  User({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }
}
