import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function(String) onNavItemTap;

  NavBar({required this.onNavItemTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavBarItem(title: 'Create Election', onTap: onNavItemTap),
          NavBarItem(title: 'Add Contestant', onTap: onNavItemTap),
          NavBarItem(title: 'Vote', onTap: onNavItemTap),
          NavBarItem(title: 'Statistics', onTap: onNavItemTap),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  final Function(String) onTap;

  NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap(title);
      },
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
