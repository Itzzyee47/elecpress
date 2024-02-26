import 'package:flutter/material.dart';
import 'package:elecpress/screens/desktop/desk_election.dart';

class ViewElectionsPage extends StatelessWidget {
  final List<Election> elections;

  ViewElectionsPage({required this.elections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Elections',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust width as needed
            child: ListView.builder(
              itemCount: elections.length,
              itemBuilder: (context, index) {
                final election = elections[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to detailed election page
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 30, // Adjust radius as needed
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 30, // Adjust icon size as needed
                        ),
                      ),
                      title: Text(
                        election.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Participants: ${election.participants}',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
