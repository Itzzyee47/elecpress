import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:elecpress/screens/mobile/contestant.dart';

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
      padding: EdgeInsets.fromLTRB(120, 20, 130, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Add Contestant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width:
                      double.infinity, // Adjust the width of the left section
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
                        decoration:
                            InputDecoration(labelText: 'Contestant Name'),
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
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              if (_imageUrl.isNotEmpty) ...[
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double
                        .infinity, // Adjust the width of the right section
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Image.file(File(_imageUrl)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final gender = _genderController.text;
              final contestant =
                  Contestant(name, gender, 0, imageUrl: _imageUrl);
              widget.onAddContestant(contestant);
              _clearFields();
            },
            child: Text('Add Contestant'),
          ),
        ],
      ),
    );
  }
}
