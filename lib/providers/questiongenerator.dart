import 'package:flutter/material.dart';
import 'dart:math';

enum difficultyMode { Easy, Medium, Hard }

class QuestionGenerator with ChangeNotifier {
  difficultyMode diff = difficultyMode.Easy;

  void setDiff(difficultyMode newDiff) {
    diff = newDiff;
  }

  List<dynamic> generateQuestion() {
    Random random = Random();
    int a, b, ans;
    List arr_1 = [], arr_2 = [];
    List<dynamic> createdQuestion;
    if (diff == difficultyMode.Easy) {
      a = random.nextInt(20);
      b = random.nextInt(20);
      arr_1 = [a + b, a - b];
      var opns = ['+', '-'];
      int opInd = random.nextInt(2);
      arr_2 = [random.nextInt(40), arr_1[opInd]];
      int ind = random.nextInt(2);
      String op = opns[opInd];
      bool chk;
      chk = arr_1[opInd] == arr_2[ind];
      createdQuestion = [a, b, op, arr_2[ind], chk];
    } else if (diff == difficultyMode.Medium) {
      a = random.nextInt(20);
      b = random.nextInt(20);
      arr_1 = [a + b, a - b, a * b];
      var opns = ['+', '-', '*'];
      int opInd = random.nextInt(3);
      arr_2 = [random.nextInt(40), arr_1[opInd]];
      int ind = random.nextInt(2);
      String op = opns[opInd];
      bool chk;
      chk = arr_1[opInd] == arr_2[ind];
      createdQuestion = [a, b, op, arr_2[ind], chk];
    } else {
      a = random.nextInt(100);
      b = random.nextInt(100);
      arr_1 = [a + b, a - b, a * b];
      var opns = ['+', '-', '*'];
      int opInd = random.nextInt(3);
      arr_2 = [random.nextInt(40), arr_1[opInd]];
      int ind = random.nextInt(2);
      String op = opns[opInd];
      bool chk;
      chk = arr_1[opInd] == arr_2[ind];
      createdQuestion = [a, b, op, arr_2[ind], chk];
    }
    return createdQuestion;
  }
}
