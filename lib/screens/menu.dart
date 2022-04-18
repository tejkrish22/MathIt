import 'package:flutter/material.dart';
import '../screens/leaderboard.dart';
import 'package:provider/provider.dart';
import '../providers/authservice.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/questiongenerator.dart';
import '../screens/myhomepage.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  static const routeName = "/menu";
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var dropVal = difficultyMode.Easy.name;
  int duration = 6;
  final diff = [
    difficultyMode.Easy.name,
    difficultyMode.Medium.name,
    difficultyMode.Hard.name,
  ];
  difficultyMode diffLevel = difficultyMode.Easy;
  final _url = "https://forms.gle/HgiwNL4M9zveYNDq8";

  void _launchURL() async {
    try {
      await launch(_url);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error Occured!'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final changDiff = Provider.of<QuestionGenerator>(context);
    final auth = Provider.of<AuthService>(context);
    final deviceSize = MediaQuery.of(context).size;
    final userName = auth.getUserName();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
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
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${userName == null ? "Welcome!" : "Hello $userName"}!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Select Difficulty",
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      dropdownColor: Colors.blue[100],
                      value: dropVal,
                      items: diff.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                              color: Colors.pink[500],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? val) {
                        setState(() {
                          dropVal = val!;
                        });
                        if (val == 'Easy') {
                          diffLevel = difficultyMode.Easy;
                        } else if (val == 'Medium') {
                          diffLevel = difficultyMode.Medium;
                        } else {
                          diffLevel = difficultyMode.Hard;
                        }
                        changDiff.setDiff(diffLevel);
                      },
                    ),
                  ],
                ),
                IconButton(
                  color: Colors.green,
                  iconSize: 80,
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyHomePage.routeName);
                  },
                  icon: Icon(
                    Icons.play_circle,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(150, 40),
                  ),
                  label: Text('Leaderboard'),
                  onPressed: () async {
                    Navigator.of(context).pushNamed(Leaderboard.routeName);
                  },
                  icon: Icon(
                    Icons.emoji_events,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(150, 40),
                  ),
                  label: Text('Log Out'),
                  onPressed: () async {
                    await auth.signOut();
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(150, 40),
                  ),
                  label: Text('Rate Us'),
                  onPressed: _launchURL,
                  icon: Icon(
                    Icons.star,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
