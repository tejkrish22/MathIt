import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../providers/authservice.dart';

class ForgetPass extends StatefulWidget {
  final Function? switchAuthMode;
  const ForgetPass({Key? key, this.switchAuthMode}) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  String email = '';
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState!.validate())) {
      print('validate failed');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _auth.forgetPass(email);
      if (response) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Mail sent successfully',
            ),
            content: Text("Reset your password and try logging in again."),
            actions: [
              TextButton(
                  onPressed: () {
                    widget.switchAuthMode!(AuthMode.Login);
                    Navigator.pop(ctx);
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'An Error Occured',
          ),
          content: Text(e.message!),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'))
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Forget Password",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Provide your email and we will send you a link to reset your password",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: new InputDecoration(
              label: Text('Email'),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: new BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if ((value!.isEmpty) || !(value.contains('@'))) {
                return 'Invalid Email!';
              }
              return null;
            },
            onSaved: (value) {
              email = value!.trim();
            },
          ),
        ),
        SizedBox(
          width: deviceSize.width / 0.8,
          child: ElevatedButton(
            onPressed: _submit,
            child: Text("Reset Password"),
            style: ElevatedButton.styleFrom(),
          ),
        ),
        TextButton(
          child: Text('Go back'),
          onPressed: () {
            widget.switchAuthMode!(AuthMode.Login);
          },
        ),
      ],
    );
  }
}
