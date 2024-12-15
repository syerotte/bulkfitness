import 'package:bulkfitness/components/my_appbar.dart';
import 'package:bulkfitness/components/my_square.dart';
import 'package:flutter/material.dart';
import 'challenge_detail_page.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final List<Map<String, dynamic>> _challenges = [
    {
      'title': 'Bench Press',
      'description': 'May 1 to July 31, 2024',
      'imagePath': 'lib/images/apple.png',
      'isJoined': false,
      'progress': 0.0,
      'detailedDescription': 'Challenge yourself to improve your bench press strength over three months. This challenge will help you build chest strength and overall upper body power.',
      'goal': 'Increase your bench press 1RM by 10%',
      'badge': 'Earn a Bench Press Beast badge',
      'overview': 'Push yourself to increase your bench press one-rep max (1RM) by 10% over the course of three months. Follow a structured program and track your progress!',
      'rules': [
        'Perform bench press exercises at least twice a week.',
        'Log your working sets and 1RM attempts in the app.',
        'Ensure proper form to prevent injury.',
        'Rest adequately between heavy lifting sessions.',
      ],
    },
    {
      'title': 'Deadlift',
      'description': 'June 1 to Aug 31, 2024',
      'imagePath': 'lib/images/apple.png',
      'isJoined': false,
      'progress': 0.0,
      'detailedDescription': 'Master the king of lifts with this deadlift challenge. Focus on perfecting your form and increasing your strength in this fundamental compound exercise.',
      'goal': 'Deadlift 2x your body weight',
      'badge': 'Earn a Deadlift Dominator badge',
      'overview': 'Challenge yourself to deadlift twice your body weight by the end of the three-month period. This will significantly improve your overall strength and power.',
      'rules': [
        'Deadlift at least once a week, following a progressive overload program.',
        'Record your lifts and body weight in the app regularly.',
        'Maintain strict form to maximize gains and prevent injury.',
        'Incorporate accessory exercises to support your deadlift progress.',
      ],
    },
    {
      'title': 'Squat',
      'description': 'July 1 to Sept 30, 2024',
      'imagePath': 'lib/images/apple.png',
      'isJoined': false,
      'progress': 0.0,
      'detailedDescription': 'Build lower body strength and muscle with this squat challenge. Squats are a fundamental exercise for overall fitness and athletic performance.',
      'goal': 'Perform 1,000 squats in a month',
      'badge': 'Earn a Squat Supreme badge',
      'overview': 'Challenge yourself to perform 1,000 squats over the course of a month. Mix it up with bodyweight squats, weighted squats, and variations to keep it interesting!',
      'rules': [
        'Perform squats at least 3 times a week.',
        'Log your squat sessions and rep counts in the app.',
        'Include a variety of squat types (e.g., back squats, front squats, goblet squats).',
        'Ensure proper depth and form for each rep to count.',
      ],
    },
  ];

  void _navigateToChallengeDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailPage(
          title: _challenges[index]['title'],
          description: _challenges[index]['description'],
          imagePath: _challenges[index]['imagePath'],
          isJoined: _challenges[index]['isJoined'],
          detailedDescription: _challenges[index]['detailedDescription'],
          goal: _challenges[index]['goal'],
          badge: _challenges[index]['badge'],
          overview: _challenges[index]['overview'],
          rules: _challenges[index]['rules'],
          progress: _challenges[index]['progress'],
          onJoinStatusChanged: (bool newStatus) {
            setState(() {
              _challenges[index]['isJoined'] = newStatus;
              if (newStatus) {
                _challenges[index]['progress'] = 0.0;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Weekly Challenges",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _navigateToChallengeDetail(index),
                  child: MySquare(
                    title: _challenges[index]['title'],
                    description: _challenges[index]['description'],
                    imagePath: _challenges[index]['imagePath'],
                    onPressed: () => _navigateToChallengeDetail(index),
                    isJoined: _challenges[index]['isJoined'],
                    progress: _challenges[index]['progress'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}