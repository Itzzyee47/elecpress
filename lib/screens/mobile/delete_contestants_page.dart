import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contestant.dart';

class DeleteContestantsPage extends StatelessWidget {
  final List<Contestant> contestants;

  DeleteContestantsPage({required this.contestants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Contestants'),
      ),
      body: ListView.builder(
        itemCount: contestants.length,
        itemBuilder: (context, index) {
          Contestant contestant = contestants[index];
          return ListTile(
            title: Text('${index + 1}. ${contestant.name}'),
            trailing: Text('Votes: ${contestant.votes}'),
            onTap: () {
              // Show confirmation dialog before deleting contestant
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text(
                        'Are you sure you want to delete ${contestant.name}?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Delete the contestant
                          contestants.removeAt(index);
                          await _saveContestants(); // Save changes to SharedPreferences
                          Navigator.of(context).pop(); // Close the dialog
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${contestant.name} deleted'),
                          ));
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to save the updated list of contestants to SharedPreferences
  Future<void> _saveContestants() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contestantStrings =
        contestants.map((contestant) => contestant.toJson()).toList();
    await prefs.setStringList('contestants', contestantStrings);
  }
}
