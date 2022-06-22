class Questions {
  late int id;
  late String question;
  String? description, difficulty, category, tip, explanation;
  late List options, answers;
  late List tags;

  Questions(
      {required this.id,
      required this.answers,
      required this.category,
      required this.description,
      required this.difficulty,
      required this.explanation,
      required this.options,
      required this.question,
      required this.tags,
      required this.tip});

  factory Questions.fromJson(Map<String, dynamic> json) {
    List ansList = json['correct_answers'] == null
        ? []
        : json['correct_answers'].entries.map((e) {
            return e.value;
          }).toList();
    ansList.removeWhere((element) => element == null);
    List oplist = json['answers'] == null
        ? []
        : json['answers'].entries.map((e) {
            return e.value;
          }).toList();
    oplist.removeWhere((element) => element == null);
    List tagList = json['tags'].map((e) {
      if (e['name'] != null) {
        return e['name'];
      }
    }).toList();

    return Questions(
        id: json['id'],
        answers: ansList,
        category: json['category'],
        description: json['description'],
        difficulty: json['difficulty'],
        explanation: json['explanation'],
        options: oplist,
        question: json['question'],
        tags: tagList,
        tip: json['tip']);
  }

  toJson() {
    return {
      'id': id,
        'answers': answers,
        'category': category,
        'description': description,
        'difficulty':difficulty,
        'explanation': explanation,
        'options': options,
        'question': question,
        'tags': tags,
        'tip': tip
    };
  }
}
