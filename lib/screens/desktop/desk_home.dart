import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'desk_add_contestant.dart';
import 'package:elecpress/screens/mobile/contestant.dart';
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

  @override
  void initState() {
    super.initState();
    _loadContestants();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presbytarian Elections 2024 - ELECTPRESS24'),
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
                    ),
                  ] else if (activeSection == 'Statistics') ...[
                    StatisticsSection(
                      contestants: contestants,
                    ),
                  ],
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
