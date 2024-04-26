import 'package:flash_cards/widgets/circular_result.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';

class TestHistoryPage extends StatefulWidget {
  const TestHistoryPage({super.key});

  @override
  State<TestHistoryPage> createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  List<Map<String, dynamic>> testResults = [];

  void getTestResults() async {
    List<Map<String, dynamic>> _testResults = await DatabaseServices.getAllTestResults();
    // debugPrint(_testResults as String?);

    setState(() {
      testResults = _testResults;
    });
  }

  @override
  void initState() {
    super.initState();

    getTestResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests History"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: testResults.isNotEmpty ? Column(
            children: [
              for (var test in testResults) Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          test["cardsSetName"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircularResult(
                            size: 42,
                            percentage: test["percentage"]
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ) : Text("No test results."),
        ),
      ),
    );
  }
}
