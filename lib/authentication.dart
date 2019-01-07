import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class AuthenticationService {
  final _userController = ReplaySubject<String>(maxSize: 1);

  AuthenticationService() {
    Future.delayed(Duration(seconds: 10)).then((value) => _userController.add(null)); //Simulate loading
  }

  void login() {
    _userController.sink.add('User');
  }

  void logout() {
    _userController.sink.add(null);
  }

  Stream<String> user() {
    return _userController.asBroadcastStream();
  }

  dispose() {
    _userController.sink.close();
  }
}
class AuthenticationProvider extends InheritedWidget {
  final service = AuthenticationService();
  AuthenticationProvider({Key key, child}) : super(key: key, child: child);

  static AuthenticationService of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthenticationProvider)as AuthenticationProvider).service;
  }

  @override
  bool updateShouldNotify( AuthenticationProvider oldWidget) {
    return true;
  }
}