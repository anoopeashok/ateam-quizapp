import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/screens/quiz/quiz_viewmodel.dart';

class QuizView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizViewmodel(),
      child: Consumer<QuizViewmodel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.purple,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
            ],
          ),
          body: model.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QuestionIndicator(model),
                          Expanded(
                            child: PageView.builder(
                                controller: model.controller,
                                scrollDirection: Axis.horizontal,
                                itemCount: model.questions.length,
                                itemBuilder: (context, index) => QuestionCard(
                                      index: index + 1,
                                      questions: model.questions[index],
                                      model: model,
                                    )),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          model.submit();
                          result(context,model);
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
        ),
      ),
    );
  }

    result(context, QuizViewmodel model) {
    showDialog(
      context: context,
      builder: (context)=>
         AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title:  Text(
                  'Quiz Result',
                  style: TextStyle(fontSize: 20),
                ),
          content:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const SizedBox(
                  height: 20,
                ),
                Text('Correct ${model.totalCorrect}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('InCorrect ${model.totalWrong}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Unattended ${model.totalUnattended}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
              ],
            ),
        )
      
    );
  }

 
}

class QuestionCard extends StatelessWidget {
  int index;
  Questions questions;
  QuizViewmodel model;

  QuestionCard(
      {required this.index, required this.questions, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Questions $index/10')),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(questions.question),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < questions.options.length; i++)
                  model.selectedOption[index - 1] != i + 1
                      ? options(questions.options[i], i + 1, index, model)
                      : selectedOption(questions.options[i], i + 1)
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget options(text, index, qstno, QuizViewmodel model) {
    return InkWell(
      onTap: () {
        model.markAnswer(qstno, index);
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.black)),
        child: Text('$index.$text'),
      ),
    );
  }
}

Widget selectedOption(text, index) {
  return Container(
    width: 200,
    margin: EdgeInsets.symmetric(vertical: 4),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.white)),
    child: Text(
      '$index.$text',
      style: TextStyle(color: Colors.white),
    ),
  );
}

class QuestionIndicator extends StatelessWidget {
  QuizViewmodel model;
  QuestionIndicator(this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        controller: model.scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < model.scoresStatus.length; i++)
              checkCurrentStatus(model.scoresStatus[i], i + 1)
          ],
        ),
      ),
    );
  }

  Widget checkCurrentStatus(Score score, int index) {
    switch (score) {
      case Score.correct:
        return correct();
      case Score.notattended:
        return notAttended(index);
      case Score.wrong:
        return wrong();
    }
  }

  Widget notAttended(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Text('$index'),
      ),
    );
  }

  Widget selected(index) {
    return Container(
      height: 20,
      width: 20,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.black)),
      child: Text('$index'),
    );
  }

  Widget correct() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.white)),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget wrong() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.red)),
        child: const Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
    );
  }

}
