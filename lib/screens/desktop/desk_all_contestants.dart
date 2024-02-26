import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:elecpress/screens/desktop/desk_contestant.dart';
import 'package:elecpress/screens/desktop/contestant_detail.dart';

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
    filteredContestants = widget.contestants;
  }

  void filterContestants(String criteria) {
    setState(() {
      filteredContestants = widget.contestants.where((contestant) {
        return contestant.gender == criteria;
      }).toList();
    });
  }

  Future<void> exportToFile(String fileExtension) async {
    final StringBuffer buffer = StringBuffer();

    for (var contestant in filteredContestants) {
      buffer.writeln('Name: ${contestant.name}');
      buffer.writeln('Gender: ${contestant.gender}');
      buffer.writeln('Votes: ${contestant.votes}');
      buffer.writeln();
    }

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fileName = 'contestants.$fileExtension';
    final String filePath = '$dir/$fileName';
    final File file = File(filePath);
    await file.writeAsString(buffer.toString());
    print('File exported at $filePath');

    _showExportSuccessPopup(filePath);
  }

  void _showExportSuccessPopup(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('File exported successfully at:'),
              SizedBox(height: 10),
              Text(filePath),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Contestants'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => exportToFile(value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'txt',
                child: Text('Export as TXT'),
              ),
              PopupMenuItem<String>(
                value: 'csv',
                child: Text('Export as CSV'),
              ),
              PopupMenuItem<String>(
                value: 'pdf',
                child: Text('Export as PDF'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(260, 20, 230, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => filterContestants('male'),
                  child: Text('Male'),
                ),
                ElevatedButton(
                  onPressed: () => filterContestants('female'),
                  child: Text('Female'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filteredContestants = widget.contestants;
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContestants.length,
                itemBuilder: (context, index) {
                  Contestant contestant = filteredContestants[index];
                  return ListTile(
                    title: Text('${index + 1}. ${contestant.name}'),
                    trailing: Text('Votes: ${contestant.votes}'),
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
      ),
    );
  }
}
