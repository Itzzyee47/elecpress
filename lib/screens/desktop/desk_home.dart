import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elecpress/screens/desktop/desk_contestant.dart';
import 'about.dart';
import 'desk_add_contestant.dart';
import 'package:elecpress/screens/desktop/desk_election.dart';
import 'package:elecpress/screens/desktop/desk_view_election.dart';
import 'package:elecpress/screens/desktop/desk_vote_secton.dart';
import 'package:elecpress/screens/desktop/desk_statistics_section.dart';
import 'package:elecpress/screens/mobile/app_sidebar.dart';
import 'package:elecpress/screens/desktop/desk_all_contestants.dart';
import 'package:elecpress/screens/desktop/desk_delete_contestants_page.dart';

class DesktopView extends StatefulWidget {
  @override
  _DesktopViewState createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  String activeSection = 'Add Contestant';
  List<Contestant> contestants = [];
  List<Election> elections = []; // List to store elections

  @override
  void initState() {
    super.initState();
    _loadContestants();
    _loadElections(); // Load elections when the widget initializes
  }

  Future<void> _loadContestants() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? contestantStrings = prefs.getStringList('contestants');
    if (contestantStrings != null) {
      contestants = contestantStrings
          .map((string) => Contestant.fromJson(string))
          .toList();
      setState(() {});
    }
  }

  Future<void> _saveContestants() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contestantStrings =
        contestants.map((contestant) => contestant.toJson()).toList();
    await prefs.setStringList('contestants', contestantStrings);
  }

  Future<void> _loadElections() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? electionStrings = prefs.getStringList('elections');
    if (electionStrings != null) {
      elections =
          electionStrings.map((string) => Election.fromJson(string)).toList();
      setState(() {});
    }
  }

  Future<void> _saveElections() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> electionStrings =
        elections.map((election) => election.toJson()).toList();
    await prefs.setStringList('elections', electionStrings);
  }

  Future<bool> _checkExistingContestant(String name) async {
    final existingContestants =
        contestants.where((c) => c.name == name).toList();
    return existingContestants.isEmpty;
  }

  void onViewAllContestants() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllContestantsPage(contestants: contestants),
      ),
    );
  }

  void onDeleteContestants() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteContestantsPage(contestants: contestants),
      ),
    );
  }

  void onAddElection(Election election) {
    setState(() {
      elections.add(election); // Add the election to the list
      _saveElections(); // Save the elections
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Presbyterian Elections 2024 - ELECTPRESS24',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: Row(
        children: [
          // Side panel with navigation items
          Container(
            width: 200, // Adjust width as needed
            color: Colors.blue.shade900, // Dark blue background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: Icon(Icons.add, color: Colors.blue),
                  title: Text(
                    'Add Election',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionPage(
                          onSaveElection: onAddElection,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_list, color: Colors.green),
                  title: Text(
                    'View Elections',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewElectionsPage(elections: elections),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.orange),
                  title: Text(
                    'Add Contestant',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      activeSection = 'Add Contestant';
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.how_to_vote, color: Colors.red),
                  title: Text(
                    'Vote',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      activeSection = 'Vote';
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart, color: Colors.purple),
                  title: Text(
                    'Statistics',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      activeSection = 'Statistics';
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list, color: Colors.yellow),
                  title: Text(
                    'View All Contestants',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: onViewAllContestants,
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Delete Contestants',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: onDeleteContestants,
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text(
                    'About',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      activeSection = 'About';
                    });
                  },
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (activeSection == 'Add Contestant') ...[
                    AddContestantSection(
                      onAddContestant: (contestant) async {
                        final isUnique =
                            await _checkExistingContestant(contestant.name);
                        if (isUnique) {
                          setState(() {
                            contestants.add(contestant);
                          });
                          _saveContestants();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Duplicate Name'),
                                content: Text(
                                    'A contestant with the same name already exists.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      elections: elections,
                    ),
                  ] else if (activeSection == 'Vote') ...[
                    VoteSection(
                      contestants: contestants,
                      onVote: (index, isIncrement) {
                        setState(() {
                          if (isIncrement) {
                            contestants[index].votes++;
                          } else {
                            contestants[index].votes--;
                          }
                          _saveContestants();
                        });
                      },
                      elections: elections,
                    ),
                  ] else if (activeSection == 'Statistics') ...[
                    StatisticsSection(
                      contestants: contestants,
                    ),
                  ] else if (activeSection == 'About') ...[
                    AboutPage(),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppSidebar(
        onViewAllContestants: onViewAllContestants,
        onDeleteContestants: onDeleteContestants,
      ),
    );
  }
}
