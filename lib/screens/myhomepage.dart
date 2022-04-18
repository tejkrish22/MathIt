import 'package:flutter/material.dart';
import 'package:mathit/providers/authservice.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../widgets/clock.dart';
import '../providers/questiongenerator.dart';
import '../screens/menu.dart';
import '../providers/score.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = "/my-home-page";
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CountDownController _controller = CountDownController();
  var _score = 0;
  var high_score = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      try {
        final uid = Provider.of<AuthService>(context, listen: false).userId();
        final diff =
            Provider.of<QuestionGenerator>(context, listen: false).diff;
        await Provider.of<Score>(context, listen: false).getScores(uid);
        final data = Provider.of<Score>(context, listen: false).scores;
        if (diff == difficultyMode.Easy) {
          high_score = data['easyScore'];
        } else if (diff == difficultyMode.Medium) {
          high_score = data['mediumScore'];
        } else {
          high_score = data['hardScore'];
        }
      } catch (e) {
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final question = Provider.of<QuestionGenerator>(context).generateQuestion();
    final diffLevel = Provider.of<QuestionGenerator>(context).diff;
    final uid = Provider.of<AuthService>(context).userId();
    final scoreHandle = Provider.of<Score>(context);
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Score: $_score",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.emoji_events,
                            size: 50,
                          ),
                        ),
                        Text(
                          "$high_score",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: deviceSize.width * 0.8,
                  height: deviceSize.height * 0.2,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.withOpacity(0.7),
                        Colors.blueGrey,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "${question[0].toString()} ${question[2].toString()} ${question[1].toString()} = ${question[3].toString()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MyClock(
                  diff: Provider.of<QuestionGenerator>(context).diff,
                  controller: _controller,
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24),
                      ),
                      onPressed: () async {
                        if (question[4] == true) {
                          _controller.restart();

                          setState(() {
                            _score = _score + 1;
                          });
                        } else {
                          _controller.pause();
                          scoreHandle.setScore(
                              scr: _score, diff: diffLevel, uid: uid);
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Game Over!'),
                              content: Text('Your Score is $_score'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context)
                                        .popAndPushNamed(MyHomePage.routeName);

                                    // Navigator.of(context)
                                    //     .pushNamed(MyHomePage.routeName);
                                  },
                                  child: Text('Replay'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Menu'),
                                ),
                              ],
                            ),
                          );
                          setState(() {
                            _score = 0;
                          });
                        }
                      },
                      child: Icon(
                        Icons.check,
                        size: deviceSize.width / 5,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24),
                      ),
                      onPressed: () async {
                        if (question[4] == false) {
                          _controller.restart();
                          setState(() {
                            _score = _score + 1;
                          });
                        } else {
                          _controller.pause();
                          scoreHandle.setScore(
                              scr: _score, diff: diffLevel, uid: uid);
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Game Over!'),
                              content: Text('Your Score is $_score'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context)
                                        .popAndPushNamed(MyHomePage.routeName);

                                    // Navigator.of(context)
                                    //     .pushNamed(MyHomePage.routeName);
                                  },
                                  child: Text('Replay'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pop();
                                    // Navigator.of(context)
                                    //     .pushNamed(Menu.routeName);
                                  },
                                  child: Text('Menu'),
                                ),
                              ],
                            ),
                          );
                          setState(() {
                            _score = 0;
                          });
                        }
                        //   }
                      },
                      child: Icon(
                        Icons.close,
                        size: deviceSize.width / 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
