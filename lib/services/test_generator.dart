import 'dart:math';

import 'package:flutter/cupertino.dart';

const int maxNumberOfTerms = 14;

class TestGenerator {
  static List<T> sublistAndRemove<T>(List<T> list, int start, [int? end]) {
    end ??= list.length;
    final sublist = list.sublist(start, end);
    list.removeRange(start, end);
    return sublist;
  }

  static List<dynamic> selectRandomTerms(List<dynamic> terms) {
    List<dynamic> shuffledTerms = List.from(terms)..shuffle();
    return shuffledTerms.sublist(0, min(maxNumberOfTerms, shuffledTerms.length));
  }

  static Map<String, dynamic> generateTest(List<dynamic> terms) {
    List<dynamic> termsCopy = List.from(terms);
    List<dynamic> selectedTerms = selectRandomTerms(terms);

    List<dynamic> multipleChoiceTerms = sublistAndRemove(selectedTerms, 0, selectedTerms.length ~/ 2);
    List<dynamic> trueFalseTerms = selectedTerms;

    List<Map<String, dynamic>> trueFalseItems = trueFalseTerms.map((item) {
      bool number = Random().nextBool();
      termsCopy.removeWhere((a) => a["id"] == item["id"]);

      if (number) {
        int randomNumber = Random().nextInt(termsCopy.length);
        dynamic incorrectAnswer = termsCopy[randomNumber];

        termsCopy = [...termsCopy, incorrectAnswer];

        return {
          'id': item["id"],
          'term': item["term"],
          'definition': item["definition"],
          'isTrue': false,
          'userAnswer': null,
          'incorrectAnswer': incorrectAnswer,
        };
      }
      return {
        'id': item["id"],
        'term': item["term"],
        'definition': item["definition"],
        'isTrue': true,
        'userAnswer': null,
        'incorrectAnswer': null
      };
    }).toList();

    List<Map<String, dynamic>> multipleChoiceItems = multipleChoiceTerms.map((item) {
      termsCopy.removeWhere((a) => a["id"] == item["id"]);
      List<dynamic> possibleAnswers = [];

      for (int i = 0; i < 3; i++) {
        int randomNumber = Random().nextInt(termsCopy.length);
        dynamic choiceItem = termsCopy[randomNumber];
        possibleAnswers.add(choiceItem);
        termsCopy.removeWhere((a) => a["id"] == choiceItem["id"]);
      }

      possibleAnswers.add(item);
      possibleAnswers.shuffle();

      termsCopy = [...termsCopy, ...possibleAnswers];

      return {
        'id': item["id"],
        'term': item["term"],
        'definition': item["definition"],
        'possibleAnswers': possibleAnswers,
        'isCorrect': false,
        'userAnswer': null
      };
    }).toList();

    Map<String, dynamic> generatedTest = {
      'trueFalse': trueFalseItems,
      'multipleChoice': multipleChoiceItems,
    };

    return generatedTest;
  }
}