import 'package:flutter/material.dart';
import 'package:bulkfitness/components/my_appbar.dart';
import 'workout_tracking_page.dart';
import 'custom_workout_page.dart';
import 'workout_split_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Workout Section (Entire box is tappable)
              GestureDetector(
                onTap: () {
                  // Navigate to WorkoutTrackingPage when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutTrackingPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Push Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Bench Press, Shoulder Press, Pec Fly, Lateral Raise, Single Arm Tricep Extension',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Centered 'Start' button within the box
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Also navigate to WorkoutTrackingPage when the button is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkoutTrackingPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Start'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Workout Options Section
              Row(
                children: [
                  // Start Custom Workout Option
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomWorkoutPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.fitness_center,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start Custom\nWorkout',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Workout Split Option
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkoutSplitPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.list_alt,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Workout\nSplit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Suggested Workouts Section
              const Text(
                'Suggested',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal Scroll for Suggested Workouts
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildWorkoutCard(
                      'BEGINNER',
                      '5 EXERCISES',
                      'lib/images/beginner.jpg',
                    ),
                    const SizedBox(width: 16),
                    _buildWorkoutCard(
                      'INTERMEDIATE',
                      '7 EXERCISES',
                      'lib/images/intermediate.jpeg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build each workout card
  Widget _buildWorkoutCard(String level, String exercises, String imagePath) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              exercises,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}