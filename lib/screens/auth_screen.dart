import 'package:flutter/material.dart';
import '../widgets/auth_card.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: deviceSize.height / 4,
                    width: deviceSize.width / 4,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/icons/mathiticon.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Math It!",
                      style: GoogleFonts.lato(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Authcard(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
