import 'package:flutter/material.dart';
import 'package:bulkfitness/components/my_add_discard.dart';
import 'package:bulkfitness/components/my_appbar.dart';
import 'package:bulkfitness/components/my_timer.dart';
import 'package:bulkfitness/pages/home/exercise_library_page.dart';
import 'package:bulkfitness/components/my_add_set.dart';

class CustomWorkoutPage extends StatefulWidget {
  const CustomWorkoutPage({Key? key}) : super(key: key);

  @override
  _CustomWorkoutPageState createState() => _CustomWorkoutPageState();
}

class _CustomWorkoutPageState extends State<CustomWorkoutPage> {
  bool isRestTimerRunning = false;
  List<Map<String, dynamic>> exercises = [];

  // Sample history data for exercises
  final Map<String, Map<String, dynamic>> sampleHistoryData = {
    'Bench Press': {'weight': 50, 'reps': 6},
    'Shoulder Press': {'weight': 20, 'reps': 8},
    'Deadlift': {'weight': 100, 'reps': 4},
    'Dumbbell Bicep Curl': {'weight': 15, 'reps': 10},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppbar(
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: MyTimer(
                initialSeconds: 0,
                isWorkoutTimer: true,
                onFinish: () {
                  // Implement your logic to save the workout session here
                  print('Workout finished!');
                  // You might want to navigate to a summary page or show a dialog
                },
              ),
            ),
          ),
          Expanded(
            child: exercises.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Start Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add exercise to start your workout',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseSection(exercises[index]);
              },
            ),
          ),
          MyAddDiscard(
            onAddExercise: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseLibraryPage(
                    onExercisesSelected: (selectedExercises) {
                      setState(() {
                        for (var exercise in selectedExercises) {
                          if (!exercises.any((e) => e['title'] == exercise['title'])) {
                            exercises.add(_addInitialSetToExercise(exercise));
                          }
                        }
                      });
                    },
                    multiSelect: true,
                    initialSelectedExercises: exercises,
                  ),
                ),
              );
            },
            onDiscardWorkout: () {
              Navigator.pop(context);
            },
            onRestTimerComplete: () {
              setState(() {
                isRestTimerRunning = false;
              });
            },
            isRestTimerRunning: isRestTimerRunning,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSection(Map<String, dynamic> exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(exercise['icon'] as IconData, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              exercise['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                _showExerciseOptions(exercise);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  SizedBox(width: 60, child: Text('Set', style: TextStyle(color: Colors.grey, fontSize: 12))),
                  Expanded(child: Text('Weight', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center)),
                  Expanded(child: Text('Reps', style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center)),
                  SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 8),
            MyAddSet(
              set: exercise['history'],
              isHistory: true,
              onComplete: (_) {},
              onUpdate: (_, __) {},
            ),
            ...(exercise['sets'] as List<Map<String, dynamic>>).map((set) => MyAddSet(
              set: set,
              isHistory: false,
              onComplete: (isCompleted) {
                setState(() {
                  isRestTimerRunning = isCompleted;
                });
              },
              onUpdate: (field, value) {
                setState(() {
                  set[field] = int.tryParse(value) ?? 0;
                });
              },
            )).toList(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    (exercise['sets'] as List<Map<String, dynamic>>).add({
                      'set': (exercise['sets'] as List).length + 1,
                      'weight': 0,
                      'reps': 0,
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Add Set'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _showExerciseOptions(Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _swapExercise(exercise);
                },
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text('Swap Exercise', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    exercises.remove(exercise);
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Delete Exercise', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _swapExercise(Map<String, dynamic> oldExercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseLibraryPage(
          onExercisesSelected: (selectedExercises) {
            setState(() {
              int index = exercises.indexOf(oldExercise);
              if (selectedExercises.isNotEmpty) {
                // Create new exercise with initial values
                Map<String, dynamic> newExercise = Map<String, dynamic>.from(selectedExercises.first);
                // Create new sets with same count as old exercise but with 0 values
                List<Map<String, dynamic>> newSets = List.generate(
                    (oldExercise['sets'] as List).length,
                        (i) => {'set': i + 1, 'weight': 0, 'reps': 0}
                );
                // Set sample history data or default to 0 if not found
                newExercise['history'] = sampleHistoryData[newExercise['title']] ?? {'weight': 0, 'reps': 0};
                newExercise['sets'] = newSets;
                exercises[index] = newExercise;
              }
            });
          },
          multiSelect: false,
          initialSelectedExercises: exercises,
          exerciseToSwap: oldExercise,
        ),
      ),
    );
  }

  Map<String, dynamic> _addInitialSetToExercise(Map<String, dynamic> exercise) {
    exercise['history'] = sampleHistoryData[exercise['title']] ?? {'weight': 0, 'reps': 0};
    exercise['sets'] = <Map<String, dynamic>>[
      {'set': 1, 'weight': 0, 'reps': 0}
    ];
    return exercise;
  }
}
