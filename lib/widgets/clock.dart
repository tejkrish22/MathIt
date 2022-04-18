import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../screens/myhomepage.dart';
import '../providers/questiongenerator.dart';

class MyClock extends StatefulWidget {
  final CountDownController? controller;
  final difficultyMode? diff;
  const MyClock({Key? key, this.controller, this.diff}) : super(key: key);

  @override
  State<MyClock> createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: widget.diff == difficultyMode.Easy
            ? 2
            : widget.diff == difficultyMode.Medium
                ? 2
                : 4,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: widget.controller!,

        // Width of the Countdown Widget.
        width: 100,

        // Height of the Countdown Widget.
        height: 100,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Colors.purpleAccent[100]!,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.purple[500],

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 20.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.round,

        // Text Style for Countdown Text.
        textStyle: const TextStyle(
          fontSize: 33.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.S,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: true,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: true,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: true,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          debugPrint('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Game Over!'),
              content: Text('Time Up!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(MyHomePage.routeName);
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
        },
      ),
    );
  }
}
