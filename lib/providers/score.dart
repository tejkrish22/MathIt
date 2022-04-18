import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/questiongenerator.dart';

class Score with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> scores = {};
  Future<void> getScores(String uid) async {
    try {
      final ref = await firestore.collection('users').doc(uid).get();
      Map<String, dynamic> data = ref.data() as Map<String, dynamic>;
      scores = data;
    } on FirebaseException {
      rethrow;
    }
  }

  void setScore(
      {required int scr,
      required difficultyMode diff,
      required String uid}) async {
    try {
      final ref = firestore.collection('users').doc(uid);
      if (diff == difficultyMode.Easy && scores['easyScore'] < scr) {
        print("hit1");
        ref.update({
          'easyScore': scr,
        });
      } else if (diff == difficultyMode.Medium && scores['mediumScore'] < scr) {
        ref.update({
          'mediumScore': scr,
        });
      } else if (scores['hardScore'] < scr) {
        ref.update({
          'hardScore': scr,
        });
      }
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> topScores(difficultyMode diff) async {
    print('hit2');
    try {
      List<Map<String, dynamic>> arr = [];
      QuerySnapshot<Map<String, dynamic>> snap;
      final ref = firestore.collection('users');
      if (diff == difficultyMode.Easy) {
        snap = await ref.orderBy('easyScore', descending: true).limit(10).get();
      } else if (diff == difficultyMode.Medium) {
        snap =
            await ref.orderBy('mediumScore', descending: true).limit(10).get();
      } else {
        snap = await ref.orderBy('hardScore', descending: true).limit(10).get();
      }
      for (int i = 0; i < snap.docs.length; i++) {
        var a = snap.docs[i];
        arr.add(a.data());
      }
      return (arr);
    } on FirebaseException catch (e) {
      print(e.message);
      rethrow;
    }
  }
}
