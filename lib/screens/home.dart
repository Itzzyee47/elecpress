import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for the File class from dart:io

void main() {
  runApp(MyApp());
}

class Contestant {
  String name;
  String gender;
  int votes;
  String imageUrl;

  Contestant(this.name, this.gender, this.votes, {this.imageUrl = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'votes': votes,
      'imageUrl': imageUrl,
    };
  }

  factory Contestant.fromMap(Map<String, dynamic> map) {
    return Contestant(
      map['name'],
      map['gender'],
      map['votes'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contestant.fromJson(String source) =>
      Contestant.fromMap(json.decode(source));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELECTPRESS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

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
    // Show all contestants page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllContestantsPage(contestants: contestants),
      ),
    );
  }

  void onDeleteContestants() {
    // Show delete contestants page
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
                onVote: (index) {
                  setState(() {
                    contestants[index].votes++;
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
      drawer: AppDrawer(
        onViewAllContestants: onViewAllContestants,
        onDeleteContestants: onDeleteContestants,
      ),
    );
  }
}

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

class AddContestantSection extends StatefulWidget {
  final Function(Contestant) onAddContestant;

  AddContestantSection({required this.onAddContestant});

  @override
  _AddContestantSectionState createState() => _AddContestantSectionState();
}

class _AddContestantSectionState extends State<AddContestantSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String _imageUrl = '';

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  // Function to clear input fields and image selection
  void _clearFields() {
    setState(() {
      _nameController.clear();
      _genderController.clear();
      _imageUrl = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Add Contestant',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Contestant Name'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Select Profile Picture'),
                ),
                if (_imageUrl.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text(
                    'Selected Profile Picture:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Image.file(File(_imageUrl)),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text;
                    final gender = _genderController.text;
                    final contestant =
                        Contestant(name, gender, 0, imageUrl: _imageUrl);
                    widget.onAddContestant(contestant);
                    _clearFields(); // Call function to clear fields after adding contestant
                  },
                  child: Text('Add Contestant'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VoteSection extends StatelessWidget {
  final List<Contestant> contestants;
  final Function(int) onVote;

  VoteSection({required this.contestants, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Vote',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: contestants.length,
            itemBuilder: (context, index) {
              Contestant contestant = contestants[index];
              return ListTile(
                title: Row(
                  children: [
                    if (contestant.imageUrl.isNotEmpty)
                      CircleAvatar(
                        backgroundImage: NetworkImage(contestant.imageUrl),
                      ),
                    SizedBox(width: 10),
                    Text(contestant.name),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        onVote(index);
                      },
                      color: Colors.blue, // Set color for the plus icon
                    ),
                    Text('${contestant.votes}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StatisticsSection extends StatelessWidget {
  final List<Contestant> contestants;

  StatisticsSection({required this.contestants});

  @override
  Widget build(BuildContext context) {
    // Sort contestants by votes
    contestants.sort((a, b) => b.votes.compareTo(a.votes));

    // Get top 3 contestants
    final top3Contestants = contestants.take(3).toList();

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: top3Contestants.length,
            itemBuilder: (context, index) {
              Contestant contestant = top3Contestants[index];
              String award;
              switch (index) {
                case 0:
                  award = '🥇 Gold';
                  break;
                case 1:
                  award = '🥈 Silver';
                  break;
                case 2:
                  award = '🥉 Bronze';
                  break;
                default:
                  award = '';
              }
              return ListTile(
                title: Text('${index + 1}. ${contestant.name}'),
                trailing: Text('Votes: ${contestant.votes} $award'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final VoidCallback onViewAllContestants;
  final VoidCallback onDeleteContestants;

  AppDrawer({
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

class AllContestantsPage extends StatelessWidget {
  final List<Contestant> contestants;

  AllContestantsPage({required this.contestants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Contestants'),
      ),
      body: ListView.builder(
        itemCount: contestants.length,
        itemBuilder: (context, index) {
          Contestant contestant = contestants[index];
          return ListTile(
            title: Text('${index + 1}. ${contestant.name}'),
            trailing: Text('Votes: ${contestant.votes}'),
          );
        },
      ),
    );
  }
}

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
              // Delete the contestant
              contestants.removeAt(index);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
