import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
                Icons.logo_dev,
                color: Theme.of(context).colorScheme.inversePrimary
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              title: Text("H O M E"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: Icon(
                  Icons.my_library_books,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              title: Text("L I B R A R Y"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/library');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: Icon(
                  Icons.list_alt,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              title: Text("T E S T S"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tests');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
              title: Text("P R O F I L E"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}
