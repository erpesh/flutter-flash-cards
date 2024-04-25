import 'package:flash_cards/services/test-generator.dart';
import 'package:flash_cards/widgets/button.dart';
import 'package:flash_cards/widgets/test/multi_choice.dart';
import 'package:flash_cards/widgets/test/true_false.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
  double? percentage;

  final scrollController = ScrollController();

  void finishTest() {
    final maxScore = generatedTest["trueFalse"].length + generatedTest["multipleChoice"].length;

    int trueFalseCorrectCount = 0;
    int multipleChoiceCorrectCount = 0;

    for (var item in generatedTest["trueFalse"]) {
      if (item['userAnswer'] == item['isTrue']) {
        trueFalseCorrectCount++;
      }
    }

    for (var item in generatedTest["multipleChoice"]) {
      if (item['userAnswer'] == item['definition']) {
        multipleChoiceCorrectCount++;
      }
    }

    int totalCorrectCount = trueFalseCorrectCount + multipleChoiceCorrectCount;

    setState(() {
      isSubmitted = true;
      percentage = (totalCorrectCount / maxScore) * 100;
    });

    final position = scrollController.position.minScrollExtent;
    scrollController.animateTo(
      duration: Duration(milliseconds: 400),
      position,
      curve: Curves.linear,
    );
  }

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
          child: ListView(
              controller: scrollController,
              children: [
                percentage != null ?
                Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 3,
                              value: percentage! / 100,
                            ),
                          ),
                        ),
                        Center(child: Text(percentage!.toStringAsFixed(0) + "%")),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final box = context.findRenderObject() as RenderBox?;
                          await Share.shareWithResult(
                            "Test result: ${percentage!.toStringAsFixed(0)}%",
                            subject: "Test results",
                            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Text("Share")
                    )
                  ],
                ) : SizedBox(),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: generatedTest["trueFalse"].length + generatedTest["multipleChoice"].length,
                //     itemBuilder: (context, index) {
                //       if (index < generatedTest["trueFalse"].length) {
                //         // Render TrueFalseCard for the trueFalse items
                //         return TrueFalseCard(
                //           index: index,
                //           tfObject: generatedTest["trueFalse"][index],
                //           selectAnswer: (answer) {
                //             setState(() {
                //               generatedTest["trueFalse"][index]["userAnswer"] = answer;
                //               generatedTest["trueFalse"][index]["isCorrect"] = answer;
                //             });
                //           },
                //         );
                //       } else {
                //         // Render MultiChoiceCard for the multipleChoice items
                //         return MultiChoiceCard(
                //           index: index,
                //           mcObject: generatedTest["multipleChoice"][index - generatedTest["trueFalse"].length],
                //           selectAnswer: (answer) {
                //             setState(() {
                //               generatedTest["multipleChoice"][index - generatedTest["trueFalse"].length]["userAnswer"] = answer;
                //             });
                //           },
                //         );
                //       }
                //     },
                //   ),
                // ),
                Column(
                  children: [
                    for (var i = 0; i < generatedTest["trueFalse"].length; i++)
                      TrueFalseCard(
                        cardNumber: i + 1,
                        tfObject: generatedTest["trueFalse"][i],
                        selectAnswer: (answer) {
                          setState(() {
                            generatedTest["trueFalse"][i]["userAnswer"] = answer;
                          });
                        },
                      )
                  ],
                ),
                Column(
                  children: [
                    for (var i = 0; i < generatedTest["multipleChoice"].length; i++)
                      MultiChoiceCard(
                        cardNumber: (i + 1 + generatedTest["trueFalse"].length).toInt(),
                        mcObject: generatedTest["multipleChoice"][i],
                        selectAnswer: (answer) {
                          setState(() {
                            generatedTest["multipleChoice"][i]["userAnswer"] = answer;
                          });
                        },
                      )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: MyButton(
                      text: "Submit",
                      onTap: finishTest
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}
