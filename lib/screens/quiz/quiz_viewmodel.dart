import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/service/quiz_repo.dart';

enum Score { correct, wrong, notattended }

class QuizViewmodel extends ChangeNotifier {
  List scoresStatus = List.generate(10, (index) => Score.notattended);
  List selectedOption = List.generate(10, (index) => 0);
  List<Questions> questions = [];
  QuizRepo _repo = IQuizRepo();
  bool isLoading = false;
  PageController controller = PageController(viewportFraction: 0.8);
  ScrollController scrollController = ScrollController();

  int totalCorrect = 0, totalUnattended = 0, totalWrong = 0;

  QuizViewmodel() {
    getQuiz();
    controller.addListener(() {});
  }

  markAnswer(qstno, index) {
    if (scoresStatus[qstno - 1] != Score.notattended) {
      return;
    }

    Questions qstn = questions[qstno - 1];
    if (qstn.answers[index - 1] == "true") {
      scoresStatus[qstno - 1] = Score.correct;
    } else {
      scoresStatus[qstno - 1] = Score.wrong;
    }
    selectedOption[qstno - 1] = index;

    notifyListeners();
  }

  getQuiz() async {
    isLoading = true;
    notifyListeners();
    try {
      questions = await _repo.getQuiz();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
    isLoading = false;
    notifyListeners();
  }

  submit() {
    totalCorrect = 0;
    totalUnattended = 0;
    totalWrong = 0;
    scoresStatus.forEach((element) {
      if (element == Score.correct) {
        totalCorrect += 1;
      } else if (element == Score.notattended) {
        totalUnattended += 1;
      } else {
        totalWrong += 1;
      }
    });
  }
}
