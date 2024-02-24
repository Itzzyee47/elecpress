import 'package:flutter/material.dart';
import 'home.dart';
import 'contestant.dart'; // Import the Contestant class from your project

class ContestantDetailsPage extends StatelessWidget {
  final Contestant contestant;

  ContestantDetailsPage({required this.contestant});

  @override
  Widget build(BuildContext context) {
    String profileImage = contestant.gender == 'female'
        ? 'assets/images/female.png'
        : 'assets/images/male.png'; // Assuming you have these images in your assets folder

    Color backgroundColor =
        contestant.gender == 'female' ? Colors.pink : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contestant Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  SizedBox(height: 20),
                  Text(
                    contestant.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    contestant.gender == 'male' ? 'Male' : 'Female',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${contestant.votes}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Add more details about the contestant as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
