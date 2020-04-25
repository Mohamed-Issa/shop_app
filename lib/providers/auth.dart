import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDoEhEKTrzxPEUmHB4CgMbXdca5yOMKuZM';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
//    const url =
//        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDoEhEKTrzxPEUmHB4CgMbXdca5yOMKuZM';
//    final response = await http.post(url,
//        body: json.encode({
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        }));
//    print(json.decode(response.body));
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
//    const url =
//        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDoEhEKTrzxPEUmHB4CgMbXdca5yOMKuZM';
//    final response = await http.post(url,
//        body: json.encode({
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        }));
//    print(json.decode(response.body));
  }
}
