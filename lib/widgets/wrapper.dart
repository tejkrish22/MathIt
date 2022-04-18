import 'package:flutter/material.dart';
import 'package:mathit/providers/authservice.dart';
import '../screens/menu.dart';
import '../screens/myhomepage.dart';
import 'package:provider/provider.dart';
import '../providers/questiongenerator.dart';
import '../models/my_user.dart';
import '../screens/auth_screen.dart';
import '../providers/score.dart';
import '../screens/leaderboard.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => QuestionGenerator()),
        ),
        ChangeNotifierProvider(
          create: ((context) => AuthService()),
        ),
        ChangeNotifierProvider(
          create: (context) => Score(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user == null ? AuthScreen() : const Menu(),
        routes: {
          MyHomePage.routeName: (ctx) => const MyHomePage(),
          Menu.routeName: (ctx) => const Menu(),
          Leaderboard.routeName: (ctx) => const Leaderboard(),
        },
      ),
    );
  }
}
