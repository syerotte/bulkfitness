import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailPage({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> exerciseHistory = [
    {
      'day': 'Monday',
      'date': '14/6',
      'set': '3',
      'reps': '10',
      'kg': '50',
    },
    {
      'day': 'Thursday',
      'date': '17/6',
      'set': '3',
      'reps': '10',
      'kg': '50',
    },
  ];

  final List<String> howToSteps = [
    'Lie on the bench',
    'Extend your arms and grab the bar evenly, hands slightly more than shoulder-width apart',
    'Bring your shoulder blades back and dig them into the bench',
    'Arch your lower back and plant your feet flat on the floor',
    'Take a breath, unrack the bar, and bring it over your chest',
    'Inhale again and lower the barbell to your lower chest, tapping it lightly',
    'Hold for a moment and press the bar until your elbows are straight. Exhale',
  ];

  final Map<String, String> usefulTips = {
    'Grip': 'Keep your grip firm but not too tight',
    'Breathing': 'Inhale on the way down, exhale on the way up',
    'Form': 'Keep your core tight throughout the movement',
    'Safety': 'Always use a spotter for heavy lifts',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Useful Tips',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: usefulTips.entries
              .map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.key,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.value,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Day',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Set',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Reps',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'kg',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history['day']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      history['date']!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  history['set']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  history['reps']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  history['kg']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: Colors.grey[800],
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const MyAppbar(showBackButton: true),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Summary'),
              Tab(text: 'How to'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Summary Tab
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                widget.exercise['icon'] as IconData,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.exercise['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildHistoryHeader(),
                        ...exerciseHistory.map((history) => _buildHistoryItem(history)),
                      ],
                    ),
                  ),
                ),
                // How to Tab
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...howToSteps.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            '${entry.key + 1}. ${entry.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )).toList(),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: _showTipsDialog,
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Centers the row's content
                              children: const [
                                Icon(
                                  Icons.help_outline,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Useful Tips',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
