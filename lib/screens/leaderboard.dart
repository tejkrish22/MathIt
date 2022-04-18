import "package:flutter/material.dart";
import 'package:mathit/providers/questiongenerator.dart';
import 'package:provider/provider.dart';
import '../providers/score.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  static const routeName = "/leaderboard";
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  var dropVal = "nil";
  List<Map<String, dynamic>> data = [];
  difficultyMode diffLevel = difficultyMode.Easy;
  final diff = [
    "nil",
    difficultyMode.Easy.name,
    difficultyMode.Medium.name,
    difficultyMode.Hard.name,
  ];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final scoreHandle = Provider.of<Score>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: deviceSize.height / 4.5,
                width: deviceSize.width / 4.5,
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
            ),
            Container(
              child: Text(
                "Math It!",
                style: GoogleFonts.lato(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Text(
              'Leaderboard - Top 10',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                    onChanged: (String? val) async {
                      setState(() {
                        dropVal = val!;
                      });
                      if (val == "nil") {
                      } else if (val == 'Easy') {
                        diffLevel = difficultyMode.Easy;
                      } else if (val == 'Medium') {
                        diffLevel = difficultyMode.Medium;
                      } else {
                        diffLevel = difficultyMode.Hard;
                      }
                      data = await scoreHandle.topScores(diffLevel);
                      setState(() {});
                      print(data);
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
                Text(
                  'Score',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
              ],
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: data.map<Padding>(
                    ((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e['username'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              diffLevel == difficultyMode.Easy
                                  ? e['easyScore'].toString()
                                  : diffLevel == difficultyMode.Medium
                                      ? e['mediumScore'].toString()
                                      : e['hardScore'].toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      );
                    }),
                  ).toList(),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
