import 'package:flutter/material.dart';
import 'package:elecpress/screens/desktop/desk_contestant.dart';
import 'package:elecpress/screens/desktop/contestant_detail.dart';
import 'package:elecpress/screens/desktop/desk_election.dart';

class VoteSection extends StatefulWidget {
  final List<Contestant> contestants;
  final Function(int, bool) onVote;
  final List<Election> elections;

  VoteSection({
    required this.contestants,
    required this.onVote,
    required this.elections,
  });

  @override
  _VoteSectionState createState() => _VoteSectionState();
}

class _VoteSectionState extends State<VoteSection> {
  late Election? _selectedElection; // Make _selectedElection nullable

  @override
  void initState() {
    super.initState();
    _selectedElection =
        widget.elections.isNotEmpty ? widget.elections.first : null;
  }

  @override
  Widget build(BuildContext context) {
    String electionName = _selectedElection?.name ?? "No election selected";

    return Container(
      height: 900,
      width: 900, // Set a fixed height for the Container
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select Election',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          DropdownButton<Election>(
            value: _selectedElection,
            onChanged: (newValue) {
              setState(() {
                _selectedElection = newValue;
              });
            },
            items: widget.elections.map((election) {
              return DropdownMenuItem(
                value: election,
                child: Text(election.name),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            'Votes in $electionName',
            style: TextStyle(
                fontSize: 24,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Expanded(
            child: buildContestantList(),
          ),
        ],
      ),
    );
  }

  Widget buildContestantList() {
    final selectedElectionName = _selectedElection?.name;
    final contestantsForSelectedElection = widget.contestants
        .where((contestant) => contestant.electionName == selectedElectionName)
        .toList();

    return ListView.builder(
      itemCount: contestantsForSelectedElection.length,
      itemBuilder: (context, index) {
        return buildContestantTile(
            context, index, contestantsForSelectedElection[index]);
      },
    );
  }

  Widget buildContestantTile(
      BuildContext context, int index, Contestant contestant) {
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
          Expanded(
            child: Text(
              contestant.name,
              style: TextStyle(fontSize: 22),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${contestant.votes} votes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 60),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              widget.onVote(index, true);
              setState(() {
                contestant.votes++; // Increment the votes locally
              });
            },
            color: Colors.blue,
          ),
          IconButton(
            icon: Icon(
              Icons.remove,
              size: 30,
            ),
            onPressed: () {
              widget.onVote(index, false);
              setState(() {
                contestant.votes--; // Decrement the votes locally
              });
            },
            color: Colors.red,
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContestantDetailsPage(contestant: contestant),
          ),
        );
      },
    );
  }
}
