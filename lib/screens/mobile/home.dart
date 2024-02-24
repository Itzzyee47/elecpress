import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:elecpress/screens/mobile/contestant.dart';
import 'package:elecpress/screens/mobile/add_contestant_section.dart';
import 'package:elecpress/screens/mobile/vote_section.dart';
import 'package:elecpress/screens/mobile/statistics_section.dart';
import 'package:elecpress/screens/mobile/app_sidebar.dart';
import 'package:elecpress/screens/mobile/all_contestants_page.dart';
import 'package:elecpress/screens/mobile/delete_contestants_page.dart';

import 'navbar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text('ELECTPRESS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(
              onNavItemTap: (section) {
                setState(() {
                  activeSection = section;
                });
              },
            ),
            SizedBox(height: 20),
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
      drawer: AppSidebar(
        onViewAllContestants: onViewAllContestants,
        onDeleteContestants: onDeleteContestants,
      ),
    );
  }
}
