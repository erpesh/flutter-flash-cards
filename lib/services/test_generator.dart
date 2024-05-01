import 'dart:math';

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
    List<dynamic> selectedTerms = selectRandomTerms(terms);

    List<dynamic> multipleChoiceTerms = sublistAndRemove(selectedTerms, 0, selectedTerms.length ~/ 2);
    List<dynamic> trueFalseTerms = sublistAndRemove(selectedTerms, 0, selectedTerms.length);

    List<Map<String, dynamic>> trueFalseItems = trueFalseTerms.map((item) {
      bool number = Random().nextBool();
      terms.removeWhere((a) => a["id"] == item["id"]);

      if (number) {
        int randomNumber = Random().nextInt(terms.length);
        dynamic incorrectAnswer = terms[randomNumber];

        terms = [...terms, incorrectAnswer];

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
      terms.removeWhere((a) => a["id"] == item["id"]);
      List<dynamic> possibleAnswers = [];

      for (int i = 0; i < 3; i++) {
        int randomNumber = Random().nextInt(terms.length);
        dynamic choiceItem = terms[randomNumber];
        possibleAnswers.add(choiceItem);
        terms.removeWhere((a) => a["id"] == choiceItem["id"]);
      }

      possibleAnswers.add(item);
      possibleAnswers.shuffle();

      terms = [...terms, ...possibleAnswers];

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