import 'package:flash_cards/services/test-generator.dart';
import 'package:flash_cards/widgets/test/multi_choice.dart';
import 'package:flash_cards/widgets/test/true_false.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  // final List<Map<String, String>> terms;
  final List<dynamic> terms;

  const TestPage({Key? key, required this.terms}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Map<String, dynamic> generatedTest;
  bool isSubmitted = false;
  late double percentage;

  @override
  void initState() {
    super.initState();

    generatedTest = TestGenerator.generateTest(widget.terms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: isSubmitted ? _buildResultView() : _buildTestView(),
        ),
      ),
    );
  }

  Widget _buildTestView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: generatedTest["trueFalse"].length + generatedTest["multipleChoice"].length,
            itemBuilder: (context, index) {
              if (index < generatedTest["trueFalse"].length) {
                // Render TrueFalseCard for the trueFalse items
                return TrueFalseCard(
                  index: index,
                  tfObject: generatedTest["trueFalse"][index],
                  selectAnswer: (answer) {
                    setState(() {
                      generatedTest["trueFalse"][index]["userAnswer"] = answer;
                    });
                  },
                );
              } else {
                // Render MultiChoiceCard for the multipleChoice items
                return MultiChoiceCard(
                  index: index,
                  mcObject: generatedTest["multipleChoice"][index - generatedTest["trueFalse"].length],
                  selectAnswer: (answer) {
                    setState(() {
                      generatedTest["multipleChoice"][index - generatedTest["trueFalse"].length]["userAnswer"] = answer;
                    });
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildResultView() {
    return Text("Result");
  }
}
