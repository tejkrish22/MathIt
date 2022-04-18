import 'package:flutter/material.dart';
import '../providers/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInUp extends StatefulWidget {
  final AuthMode? authMode;
  final Function? switchAuthMode;
  const SignInUp({Key? key, this.authMode, this.switchAuthMode})
      : super(key: key);

  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  bool showPass = false;
  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasMinLength = false;
  bool _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
  };

  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _auth = AuthService();

  Future<void> _submit() async {
    if (!(_formKey.currentState!.validate())) {
      print('validate failed');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (widget.authMode == AuthMode.Login) {
      // Log user in
      print('form submit');
      try {
        await _auth.signIn(
          email: _authData['email']!,
          password: _authData['password']!,
        );
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
    } else {
      // Sign user up
      try {
        final response = await _auth.signUp(
          userName: _authData['username']!,
          email: _authData['email']!,
          password: _authData['password']!,
        );
        print('signup respone: $response');
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
    }
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (widget.authMode == AuthMode.Login) ? "Sign In" : "Register",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.authMode == AuthMode.Login
                    ? "Don't have an account?  "
                    : "Already have an account?  ",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (widget.authMode == AuthMode.Login) {
                    widget.switchAuthMode!(AuthMode.Signup);
                  } else {
                    widget.switchAuthMode!(AuthMode.Login);
                  }
                },
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(EdgeInsets.all(1))),
                child: Text(
                  widget.authMode == AuthMode.Login ? "Register" : "LogIn",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
          if (widget.authMode == AuthMode.Signup)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: new InputDecoration(
                  label: Text('Username'),
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
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  _authData['username'] = value!.trim();
                },
              ),
            ),
          TextFormField(
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
              _authData['email'] = value!.trim();
            },
          ),
          SizedBox(
            height: 7,
          ),
          TextFormField(
            controller: _passController,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: new BorderSide(
                  color: Colors.black,
                ),
              ),
              labelText: 'Password',
              suffixIcon: GestureDetector(
                onLongPress: () {
                  setState(() {
                    showPass = true;
                  });
                },
                onLongPressUp: () {
                  setState(() {
                    showPass = false;
                  });
                },
                child: Icon(showPass ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: showPass ? false : true,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else {
                return 'Give a password';
              }
            },
            onSaved: (value) {
              _authData['password'] = value!.trim();
            },
          ),
          SizedBox(
            height: 7,
          ),
          if (widget.authMode == AuthMode.Signup)
            TextFormField(
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: new BorderSide(
                    color: Colors.black,
                  ),
                ),
                labelText: 'Confirm Password',
                suffixIcon: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      showPass = true;
                    });
                  },
                  onLongPressUp: () {
                    setState(() {
                      showPass = false;
                    });
                  },
                  child:
                      Icon(showPass ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              obscureText: showPass ? false : true,
              validator: (value) {
                if ((value!.isEmpty) || (_passController.text != value))
                  return 'Invalid Password';
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value!.trim();
              },
            ),
          ElevatedButton(
            onPressed: () {
              _submit();
            },
            child: (_isLoading)
                ? SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    height: 15,
                    width: 15,
                  )
                : Text((widget.authMode == AuthMode.Login)
                    ? "Sign In"
                    : "Register"),
            style: ElevatedButton.styleFrom(),
          ),
          if (widget.authMode == AuthMode.Login)
            TextButton(
              child: Text('Forget Password?'),
              onPressed: () {
                widget.switchAuthMode!(AuthMode.reset);
              },
            ),
        ],
      ),
    );
  }
}
