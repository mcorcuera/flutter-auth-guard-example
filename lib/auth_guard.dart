import 'dart:async';
import 'package:flutter/material.dart';

enum AuthGuardStatus {
  authenticated,
  notAuthenticated,
}

typedef void AuthGuardUnauthenticatedHandler (BuildContext context);

class AuthGuard extends StatefulWidget {
  final Widget child;
  final Widget loadingScreen;
  final AuthGuardUnauthenticatedHandler unauthenticatedHandler;
  final Stream<AuthGuardStatus> authenticationStream;

  AuthGuard({
      @required
      this.child,
      @required
      this.loadingScreen,
      @required
      this.unauthenticatedHandler,
      @required
      this.authenticationStream,
    }) {
    assert(this.child != null);
    assert(this.loadingScreen != null);
    assert(this.unauthenticatedHandler != null);
    assert(this.authenticationStream != null);
  }

  @override
  _AuthGuardState createState() {
    return new _AuthGuardState();
  }
}

class _AuthGuardState extends State<AuthGuard> {
  StreamSubscription<AuthGuardStatus> _subscription;
  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = widget.loadingScreen;
    _subscription = widget.authenticationStream.listen(_onAuthenticationChange);
  }

  @override
  void dispose() {
    super.dispose();
    print('Dispose');
    if (_subscription != null) {
       _subscription.cancel();
       _subscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthGuardStatus>(
      stream: widget.authenticationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          currentWidget = widget.loadingScreen;
          return currentWidget;
        } else if (snapshot.data == AuthGuardStatus.authenticated) {
          currentWidget = widget.child;
        }
        return currentWidget;
      },
    );
  }

  _onAuthenticationChange(AuthGuardStatus status) {
    if (status == AuthGuardStatus.notAuthenticated) {
      widget.unauthenticatedHandler(context);
    }
  }
}
