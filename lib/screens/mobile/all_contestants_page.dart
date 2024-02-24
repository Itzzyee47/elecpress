import 'package:flutter/material.dart';

import 'home.dart';
import 'ContestantDetailsPage.dart';
import 'contestant.dart';
import 'package:elecpress/main.dart';
// import 'contestant_details_page.dart';

class AllContestantsPage extends StatefulWidget {
  final List<Contestant> contestants;

  AllContestantsPage({required this.contestants});

  @override
  _AllContestantsPageState createState() => _AllContestantsPageState();
}

class _AllContestantsPageState extends State<AllContestantsPage> {
  List<Contestant> filteredContestants = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredContestants with all contestants initially
    filteredContestants = widget.contestants;
  }

  // Function to filter contestants based on criteria
  void filterContestants(String criteria) {
    setState(() {
      filteredContestants = widget.contestants.where((contestant) {
        // Add your filtering logic here based on the provided criteria
        // For example, you can filter by gender, votes, etc.
        // Replace the condition with your own filtering condition
        return contestant.gender == criteria;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Contestants'),
      ),
      body: Column(
        children: [
          // Filter buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Filter by male contestants
                  filterContestants('male');
                },
                child: Text('Male'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Filter by female contestants
                  filterContestants('female');
                },
                child: Text('Female'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Reset to show all contestants
                  setState(() {
                    filteredContestants = widget.contestants;
                  });
                },
                child: Text('Reset'),
              ),
            ],
          ),
          // Contestants list
          Expanded(
            child: ListView.builder(
              itemCount: filteredContestants.length,
              itemBuilder: (context, index) {
                Contestant contestant = filteredContestants[index];
                return ListTile(
                  title: Text('${index + 1}. ${contestant.name}'),
                  trailing: Text('Votes: ${contestant.votes}'),
                  // Navigate to a new page when a contestant is selected
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContestantDetailsPage(contestant: contestant),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
