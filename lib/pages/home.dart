import 'package:flash_cards/pages/library.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Master Any Subject with Flashcards',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Effortlessly create, study, and compete with flashcard sets to boost your knowledge and ace your exams.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  _FeatureItem(
                    icon: Icons.save,
                    title: 'Create Flashcard Sets',
                    description: 'Easily create and customize flashcard sets on any topic.',
                  ),
                  _FeatureItem(
                    icon: Icons.menu,
                    title: 'Manage Your Sets',
                    description: 'Organize your flashcard sets, track your progress, and share them with friends and classmates.',
                  ),
                  _FeatureItem(
                    icon: Icons.search,
                    title: 'Search for Sets',
                    description: 'Discover a vast library of user-created flashcard sets on a wide range of topics. Find the perfect set to help you learn.',
                  ),
                  _FeatureItem(
                    icon: Icons.format_quote,
                    title: 'Take Quizzes',
                    description: 'Test your knowledge by competing in quizzes based on the flashcard sets you\'ve studied.',
                  ),
                  _FeatureItem(
                    icon: Icons.folder_shared,
                    title: 'Sync Across Devices',
                    description: 'Access your flashcard sets from anywhere, on any device. Your progress and data are securely synced in the cloud.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 36,
            color: Colors.blue,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
