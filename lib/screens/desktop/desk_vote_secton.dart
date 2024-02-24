import 'package:flutter/material.dart';

import 'package:elecpress/screens/mobile/contestant.dart';

class VoteSection extends StatelessWidget {
  final List<Contestant> contestants;
  final Function(int, bool) onVote;

  VoteSection({required this.contestants, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(130, 20, 120, 20),
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
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        contestant.gender == 'male'
                            ? 'assets/images/male.png'
                            : 'assets/images/female.png',
                      ),
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
                        onVote(index, true); // Increase vote
                      },
                      color: Colors.blue, // Set color for the plus icon
                    ),
                    Text(
                      '${contestant.votes}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        onVote(index, false); // Decrease vote
                      },
                      color: Colors.red, // Set color for the minus icon
                    ),
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
