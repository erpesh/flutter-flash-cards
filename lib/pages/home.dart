import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/pages/library.dart';
import 'package:flash_cards/pages/profile.dart';
import 'package:flash_cards/pages/test_history.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _routes = <Widget>[
    Text("home"),
    LibraryPage(),
    TestHistoryPage(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Flash Cards"),
      //   backgroundColor: Theme.of(context).colorScheme.background,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      // drawer: MyDrawer(),
      body: _routes.elementAt(_selectedIndex),
    );
  }
}
