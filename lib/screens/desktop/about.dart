import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ELECTPRESS24',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'ELECTPRESS24 is a cutting-edge election management system designed to facilitate fair and transparent elections in Presbyterian communities. With ELECTPRESS24, you can easily manage contestants, conduct voting processes, and analyze election statistics.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Key Features:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          _buildFeatureItem('Contestant Management',
              'Add, view, and delete contestants for your elections.'),
          _buildFeatureItem('Voting Process',
              'Conduct voting processes and track votes for each contestant.'),
          _buildFeatureItem('Election Statistics',
              'Analyze election statistics to gain insights into voting trends.'),
          SizedBox(height: 20),
          Text(
            'How to Use:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          _buildGuideItem('1. Add Election:',
              'Start by adding an election. Enter the election details such as name, date, and description.'),
          _buildGuideItem('2. Add Contestants:',
              'Once the election is created, you can add contestants who will be participating in the election.'),
          _buildGuideItem('3. Conduct Voting:',
              'During the election period, voters can cast their votes for the contestants.'),
          _buildGuideItem('4. Analyze Statistics:',
              'After the voting process is complete, you can analyze election statistics to understand the voting trends and outcomes.'),
          SizedBox(height: 20),
          Text(
            'Conceived and Developed by K2Soft Innovations',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGuideItem(String step, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
