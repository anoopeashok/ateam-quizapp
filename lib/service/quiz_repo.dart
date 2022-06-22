import 'dart:convert';

import 'package:quiz_app/models/questions.dart';
import 'package:http/http.dart' as http;

abstract class QuizRepo {
  Future<List<Questions>> getQuiz();
}

class IQuizRepo implements QuizRepo {
  final BASE_URL =
      'https://quizapi.io/api/v1/questions?apiKey=miKa0AK6KcwHjHIFwG6AVZd4fmyOM05lenRRO78f&category=linux&difficulty=Hard&limit=10';

  @override
  Future<List<Questions>> getQuiz() async {
    try {
      var response = await http.get(Uri.parse(BASE_URL));
      if (response.statusCode == 200) {
        List<Questions> qList = List<Questions>.from(
            jsonDecode(response.body).map((e) => Questions.fromJson(e)));
        return qList;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
