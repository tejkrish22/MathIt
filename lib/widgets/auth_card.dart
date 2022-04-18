import 'package:flutter/material.dart';
import '../providers/authservice.dart';
import '../widgets/forget_pass.dart';
import '../widgets/sign_in_up.dart';

class Authcard extends StatefulWidget {
  const Authcard({
    Key? key,
  }) : super(key: key);

  @override
  State<Authcard> createState() => _AuthcardState();
}

class _AuthcardState extends State<Authcard> {
  AuthMode authMode = AuthMode.Login;
  void switchAuthMode(AuthMode changeTo) {
    setState(() {
      authMode = changeTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return (authMode == AuthMode.reset)
        ? ForgetPass(switchAuthMode: switchAuthMode)
        : SignInUp(authMode: authMode, switchAuthMode: switchAuthMode);
  }
}
