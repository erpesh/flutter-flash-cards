import 'dart:math';

const int maxNumberOfTerms = 20;

class TestGenerator {
  static List<dynamic> selectRandomTerms(List<dynamic> terms) {
    List<dynamic> shuffledTerms = List.from(terms)..shuffle();
    return shuffledTerms.sublist(0, min(maxNumberOfTerms, shuffledTerms.length));
  }

  static Map<String, dynamic> generateTest(List<dynamic> terms) {
    List<dynamic> termsClone = List.from(terms);
    List<dynamic> selectedTerms = selectRandomTerms(terms);
    int selectedTermsLength = selectedTerms.length;

    List<dynamic> multipleChoiceTerms = selectedTerms.sublist(0, selectedTerms.length ~/ 4);
    List<dynamic> trueFalseTerms = selectedTerms.sublist(0, selectedTerms.length ~/ 3);

    List<dynamic> incorrectAnswers = termsClone.where((item) => !trueFalseTerms.any((trueFalseItem) => trueFalseItem["id"] == item["id"])).toList();
    List<dynamic> incorrectMultipleAnswers = termsClone.where((item) => !multipleChoiceTerms.any((mChouseItem) => mChouseItem["id"] == item["id"])).toList();

    List<dynamic> writtenTerms = (selectedTermsLength < 5) ? selectedTerms.sublist(0, selectedTerms.length) : selectedTerms.sublist(0, selectedTerms.length ~/ 2);
    List<dynamic> matchingTerms = selectedTerms.sublist(0);

    List<Map<String, dynamic>> trueFalseItems = trueFalseTerms.map((item) {
      bool number = Random().nextBool();
      if (number) {
        int randomNumber = Random().nextInt(incorrectAnswers.length);
        dynamic incorrectAnswer = incorrectAnswers.removeAt(randomNumber);
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
      List<dynamic> possibleAnswers = [];
      for (int i = 0; i < 3; i++) {
        int randomNumber = Random().nextInt(incorrectMultipleAnswers.length);
        dynamic choiceItem = incorrectMultipleAnswers.removeAt(randomNumber);
        possibleAnswers.add(choiceItem);
      }
      possibleAnswers.add(item);
      possibleAnswers.shuffle();
      return {
        'id': item["id"],
        'term': item["term"],
        'definition': item["definition"],
        'possibleAnswers': possibleAnswers,
        'isCorrect': false,
        'userAnswer': null
      };
    }).toList();

    List<Map<String, dynamic>> matchingItems = matchingTerms.map((item) {
      return {
        'id': item["id"],
        'term': item["term"],
        'definition': item["definition"],
        'isCorrect': false,
        'userAnswer': null
      };
    }).toList();

    matchingItems.shuffle();
    List<Map<String, dynamic>> matchingTestAnswers = matchingItems.map((item) => {'answer': item['term'], 'index': matchingItems.indexOf(item)}).toList();
    matchingTestAnswers.shuffle();

    Map<String, dynamic> matchingTest = {
      'items': matchingItems,
      'answers': matchingTestAnswers
    };

    List<Map<String, dynamic>> writtenItems = writtenTerms.map((item) {
      return {
        'id': item["id"],
        'term': item["term"],
        'definition': item["definition"],
        'isCorrect': false,
        'answer': null
      };
    }).toList();

    List<int> lengths = [
      trueFalseItems.length,
      multipleChoiceItems.length,
      matchingItems.length,
      writtenItems.length
    ];

    Map<String, dynamic> generatedTest = {
      'trueFalse': trueFalseItems,
      'multipleChoice': multipleChoiceItems,
      // 'matching': matchingTest,
      // 'written': writtenItems,
      // 'lengths': lengths,
      // 'totalLength': lengths.reduce((value, element) => value + element),
    };

    return generatedTest;
  }
}