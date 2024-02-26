import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:elecpress/screens/desktop/desk_contestant.dart';
import 'package:elecpress/screens/desktop/desk_election.dart';

class AddContestantSection extends StatefulWidget {
  final Function(Contestant) onAddContestant;
  final List<Election> elections;

  AddContestantSection(
      {required this.onAddContestant, required this.elections});

  @override
  _AddContestantSectionState createState() => _AddContestantSectionState();
}

class _AddContestantSectionState extends State<AddContestantSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Step 2
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String _imageUrl = '';
  late Election? _selectedElection;

  @override
  void initState() {
    super.initState();
    _selectedElection =
        widget.elections.isNotEmpty ? widget.elections.first : null;
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

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
      padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20),
      child: Form(
        // Step 1
        key: _formKey, // Step 2
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Add Contestant',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
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
                          decoration: InputDecoration(
                            labelText: 'Contestant Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _genderController,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter gender';
                            } else if (value.toLowerCase() != 'male' &&
                                value.toLowerCase() != 'female') {
                              return 'Gender must be either "male" or "female"';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<Election>(
                          value: _selectedElection,
                          onChanged: (value) {
                            setState(() {
                              _selectedElection = value;
                            });
                          },
                          items: _filteredElections(),
                          decoration: InputDecoration(
                            labelText: 'Select Election',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Step 3
                              final name = _nameController.text;
                              final gender = _genderController.text;
                              final electionName =
                                  _selectedElection?.name ?? '';
                              final contestant = Contestant(
                                name: name,
                                gender: gender,
                                votes: 0,
                                imageUrl: _imageUrl,
                                electionName: electionName,
                              );
                              widget.onAddContestant(contestant);
                              _clearFields();
                            }
                          },
                          child: Text(
                            'Add Contestant',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                if (_imageUrl.isNotEmpty) ...[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Selected Profile Picture:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          Image.file(
                            File(_imageUrl),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Election>> _filteredElections() {
    final String query = _nameController.text.toLowerCase();
    final List<Election> filtered = widget.elections.where((election) {
      final name = election.name.toLowerCase();
      return name.contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return [
        DropdownMenuItem<Election>(
          value: null,
          child: Text('No elections found'),
        )
      ];
    } else {
      return filtered.map((election) {
        return DropdownMenuItem<Election>(
          value: election,
          child: Text(election.name),
        );
      }).toList();
    }
  }
}
