import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback onViewAllContestants;
  final VoidCallback onDeleteContestants;

  AppSidebar({
    required this.onViewAllContestants,
    required this.onDeleteContestants,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('View All Contestants'),
            onTap: onViewAllContestants,
          ),
          ListTile(
            title: Text('Delete Contestants'),
            onTap: onDeleteContestants,
          ),
        ],
      ),
    );
  }
}
