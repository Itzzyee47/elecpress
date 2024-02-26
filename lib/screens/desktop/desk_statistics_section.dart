import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:elecpress/screens/desktop/desk_contestant.dart';

class StatisticsSection extends StatelessWidget {
  final List<Contestant> contestants;

  StatisticsSection({required this.contestants});

  @override
  Widget build(BuildContext context) {
    // Sort contestants by votes
    contestants.sort((a, b) => b.votes.compareTo(a.votes));

    // Get top 3 contestants for overall statistics
    final top3Contestants = contestants.take(3).toList();

    // Create series data for the bar chart
    final List<charts.Series<Contestant, String>> series = [
      charts.Series(
        id: 'Votes',
        data: contestants,
        domainFn: (Contestant contestant, _) => contestant.name,
        measureFn: (Contestant contestant, _) => contestant.votes,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Contestant contestant, _) => '${contestant.votes}',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Display bar chart
          Container(
            height: 200,
            child: charts.BarChart(
              series,
              animate: true,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Top 3 Contestants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: top3Contestants.length,
            itemBuilder: (context, index) {
              Contestant contestant = top3Contestants[index];
              String award;
              switch (index) {
                case 0:
                  award = '🥇 Gold';
                  break;
                case 1:
                  award = '🥈 Silver';
                  break;
                case 2:
                  award = '🥉 Bronze';
                  break;
                default:
                  award = '';
              }
              return ListTile(
                title: Text(
                  '${index + 1}. ${contestant.name} (${contestant.votes} votes) $award',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            'All Contestants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: contestants.length,
            itemBuilder: (context, index) {
              Contestant contestant = contestants[index];
              return ListTile(
                title: Text('${index + 1}. ${contestant.name}'),
                trailing: Text('Votes: ${contestant.votes}'),
                leading: CircleAvatar(
                  backgroundColor: contestant.gender.toLowerCase() == 'female'
                      ? Colors.pink
                      : Colors.blue,
                  child: Text(
                    contestant.gender.toLowerCase() == 'female' ? 'F' : 'M',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
