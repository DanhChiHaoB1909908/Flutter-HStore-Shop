import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return !(token == null);
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String Email, String Pass, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC5cfMCIzEz61xIBUrVNLxASVNspbebXwQ");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': Email,
          'password': Pass,
          'returnSecureToken': true,
        }),
      );
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(json.decode(response.body)['expiresIn'])),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('authData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String Email, String Pass) async {
    return _authenticate(Email, Pass, 'signUp');
  }

  Future<void> login(String Email, String Pass) async {
    return _authenticate(Email, Pass, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("authData")) {
      return false;
    }
    final userData = prefs.getString('authData');
    final authData = json.decode(userData) as Map<String, Object>;
    _expiryDate = DateTime.parse(authData['expiryDate']);
    if (!_expiryDate.isAfter(DateTime.now())) {
      return false;
    }
    _token = authData['token'];
    _userId = authData['userId'];
    notifyListeners();
    return true;
  }
}
