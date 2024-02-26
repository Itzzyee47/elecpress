import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Election model
class Election {
  final String name;
  final int participants;

  Election({
    required this.name,
    required this.participants,
  });

  // Convert election object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'participants': participants,
    };
  }
}

class ElectionPage extends StatefulWidget {
  final Function(Election)
      onSaveElection; // Callback function to save the election data

  ElectionPage({required this.onSaveElection});

  @override
  _ElectionPageState createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _participantsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _participantsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validate form input
      final String name = _nameController.text;
      final int participants = int.parse(_participantsController.text);
      final Election newElection = Election(
        name: name,
        participants: participants,
      );

      // Call the onSaveElection callback with the new election data
      widget.onSaveElection(newElection);

      // Clear form fields
      _nameController.clear();
      _participantsController.clear();

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Election created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Election'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text(
              'Create New Election',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Adjust color
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Election Name',
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name for the election.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _participantsController,
                    decoration: InputDecoration(
                      labelText: 'Number of Participants',
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of participants.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Create Election',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      padding: EdgeInsets.all(15), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Button border radius
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
