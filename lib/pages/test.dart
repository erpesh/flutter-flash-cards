import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flash_cards/services/database_services.dart';
import 'package:flash_cards/services/test_generator.dart';
import 'package:flash_cards/widgets/button.dart';
import 'package:flash_cards/widgets/circular_result.dart';
import 'package:flash_cards/widgets/test/multi_choice.dart';
import 'package:flash_cards/widgets/test/true_false.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../services/notifications.dart';

class TestPage extends StatefulWidget {
  final Map<String, dynamic> cardsSet;

  const TestPage({
    Key? key,
    required this.cardsSet
  }) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Map<String, dynamic> generatedTest;
  double? percentage;

  final scrollController = ScrollController();

  void finishTest() async {
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
      percentage = (totalCorrectCount / maxScore) * 100;
    });

    // Scroll to the top
    final position = scrollController.position.minScrollExtent;
    scrollController.animateTo(
      duration: Duration(milliseconds: 400),
      position,
      curve: Curves.linear,
    );

    // Display notification
    // await NotificationServices.displayNotification(
    //     title: "Test Results",
    //     body: "To see all your past test results go to Test History page"
    // );

    await NotificationServices.displayNotification(
        title: "Test results",
        body: "Go to Test History page to see your past test results",
        actionButtons: [NotificationActionButton(
            key: "0",
            label: "Visit",
            actionType: ActionType.SilentAction
        )],
        payload: {
          "navigate": "true"
        }
    );

    await DatabaseServices.saveTestResult(widget.cardsSet["title"], percentage!);
  }

  @override
  void initState() {
    super.initState();

    generatedTest = TestGenerator.generateTest(widget.cardsSet["terms"]);
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularResult(size: 65, percentage: percentage!),
                      ElevatedButton.icon(
                          onPressed: () async {
                            final box = context.findRenderObject() as RenderBox?;
                            await Share.share(
                              "Test result: ${percentage!.toStringAsFixed(0)}%",
                              subject: "Test results",
                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                          ),
                          icon: Icon(
                            Icons.share,
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                          label: Text(
                            "Share",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary
                            ),
                          )
                      ),
                    ],
                  ),
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
                percentage == null ?
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: MyButton(
                        text: "Submit",
                        onTap: finishTest
                    ),
                  ) : SizedBox()
              ]
          ),
        ),
      ),
    );
  }
}
