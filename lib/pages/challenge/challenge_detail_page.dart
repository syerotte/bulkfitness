import 'package:flutter/material.dart';
import 'package:bulkfitness/components/my_appbar.dart';

class ChallengeDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isJoined;
  final String detailedDescription;
  final String goal;
  final String badge;
  final String overview;
  final List<String> rules;
  final Function(bool) onJoinStatusChanged;
  final double progress;

  const ChallengeDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isJoined,
    required this.detailedDescription,
    required this.goal,
    required this.badge,
    required this.overview,
    required this.rules,
    required this.onJoinStatusChanged,
    required this.progress,
  }) : super(key: key);

  @override
  _ChallengeDetailPageState createState() => _ChallengeDetailPageState();
}

class _ChallengeDetailPageState extends State<ChallengeDetailPage> {
  late bool _isJoined;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.isJoined;
    _isActive = widget.isJoined;
  }

  void _toggleJoinStatus() {
    setState(() {
      _isJoined = !_isJoined;
      _isActive = _isJoined;
    });
    widget.onJoinStatusChanged(_isJoined);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        showBackButton: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge Icon
                  Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Challenge Title
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date Range
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Goal
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.goal,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Badge
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.badge,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Overview Section
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.overview,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rules Section
                  const Text(
                    "Rules and Guidelines",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.rules.map((rule) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 14, color: Colors.black87)),
                          Expanded(
                            child: Text(
                              rule,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Join Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _toggleJoinStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isJoined ? Colors.red : Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(180, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        _isJoined ? "Leave Challenge" : "Join Challenge",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isJoined)
                    Column(
                      children: [
                        SizedBox(
                          width: 180,
                          child: LinearProgressIndicator(
                            value: widget.progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            '${(widget.progress * 100).toInt()}% Completed',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}