import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'contestant.dart';

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
                    _clearFields();
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
