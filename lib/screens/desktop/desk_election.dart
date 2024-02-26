import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Election {
  final String id; // Unique identifier for the election
  final String name;
  final int participants;

  Election({required this.id, required this.name, required this.participants});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
    };
  }

  factory Election.fromMap(Map<String, dynamic> map) {
    return Election(
      id: map['id'],
      name: map['name'],
      participants: map['participants'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Election.fromJson(String source) =>
      Election.fromMap(json.decode(source));
}

class ElectionPage extends StatefulWidget {
  final Function(Election) onSaveElection;

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
      final String name = _nameController.text;
      final int participants = int.parse(_participantsController.text);
      final String id = Uuid().v4(); // Generate a UUID
      final Election newElection = Election(
        name: name,
        participants: participants,
        id: id,
      );

      widget.onSaveElection(newElection);

      _nameController.clear();
      _participantsController.clear();

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Election',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Election Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the election.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _participantsController,
                decoration: InputDecoration(
                  labelText: 'Number of Participants',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of participants.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Election'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
