import 'package:flash_cards/services/test_generator.dart';
import 'package:flutter_test/flutter_test.dart';

List<dynamic> sampleTerms = [
  {'id': "1", 'term': 'Term 1', 'definition': 'Definition 1'},
  {'id': "2", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "3", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "4", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "5", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "6", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "7", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "8", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "9", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "10", 'term': 'Term 2', 'definition': 'Definition 2'},
  {'id': "11", 'term': 'Term 2', 'definition': 'Definition 2'},
];

void main() {
  test('Generated test should contain valid true/false items', () {

    Map<String, dynamic> generatedTest = TestGenerator.generateTest(sampleTerms);

    generatedTest['trueFalse'].forEach((item) {
      expect(item.containsKey('id'), true);
      expect(item['id'], isA<String>());

      expect(item.containsKey('term'), true);
      expect(item['term'], isA<String>());

      expect(item.containsKey('definition'), true);
      expect(item['definition'], isA<String>());

      expect(item.containsKey('isTrue'), true);
      expect(item['isTrue'], isA<bool>());

      expect(item.containsKey('userAnswer'), true);
      expect(item['userAnswer'], isNull);

      expect(item.containsKey('incorrectAnswer'), true);
      expect(item['incorrectAnswer'], anyOf(isNull, isA<Map<String, dynamic>>())); // incorrectAnswer can be null or string
    });
  });

  test('Generated test should contain valid multiple choice items', () {

    Map<String, dynamic> generatedTest = TestGenerator.generateTest(sampleTerms);

    generatedTest['multipleChoice'].forEach((item) {
      expect(item.containsKey('id'), true);
      expect(item['id'], isA<String>());

      expect(item.containsKey('term'), true);
      expect(item['term'], isA<String>());

      expect(item.containsKey('definition'), true);
      expect(item['definition'], isA<String>());

      expect(item.containsKey('possibleAnswers'), true);
      expect(item['possibleAnswers'], isA<List<dynamic>>());

      expect(item.containsKey('isCorrect'), true);
      expect(item['isCorrect'], isA<bool>());

      expect(item.containsKey('userAnswer'), true);
      expect(item['userAnswer'], isNull);
    });
  });
}
