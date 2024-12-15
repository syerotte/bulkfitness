import 'package:flutter/material.dart';
import 'package:bulkfitness/components/my_timer.dart';

class MyAddDiscard extends StatelessWidget {
  final VoidCallback? onAddExercise;
  final VoidCallback? onDiscardWorkout;
  final VoidCallback? onRestTimerComplete;
  final bool isRestTimerRunning;

  const MyAddDiscard({
    Key? key,
    this.onAddExercise,
    this.onDiscardWorkout,
    this.onRestTimerComplete,
    required this.isRestTimerRunning,
  }) : super(key: key);

  void _showDiscardConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard Workout'),
          content: Text('Are you sure you want to discard your workout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Navigate back to the homepage
                Navigator.of(context).pushReplacementNamed('/'); // Assuming '/' is your homepage route
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Rest Timer",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              MyTimer(
                initialSeconds: 90,
                isWorkoutTimer: false,
                onComplete: onRestTimerComplete,
                isRunning: isRestTimerRunning,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Add Exercise'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDiscardConfirmation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Discard Workout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}