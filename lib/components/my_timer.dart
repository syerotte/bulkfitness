import 'dart:async';
import 'package:flutter/material.dart';

class MyTimer extends StatefulWidget {
  final int initialSeconds;
  final bool isWorkoutTimer;
  final VoidCallback? onComplete;
  final bool isRunning;
  final VoidCallback? onFinish;

  const MyTimer({
    Key? key,
    required this.initialSeconds,
    this.isWorkoutTimer = false,
    this.onComplete,
    this.isRunning = false,
    this.onFinish,
  }) : super(key: key);

  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  late int _seconds;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    if (widget.isWorkoutTimer) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(MyTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.isWorkoutTimer) {
          _seconds++;
        } else {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _stopTimer();
            widget.onComplete?.call();
          }
        }
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _seconds = widget.initialSeconds;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _showTimerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: 21, // 0 to 5 minutes in 30-second intervals
            itemBuilder: (context, index) {
              int minutes = (index * 15) ~/ 60;
              int seconds = (index * 15) % 60;
              return ListTile(
                title: Text('$minutes:${seconds.toString().padLeft(2, '0')}'),
                onTap: () {
                  setState(() {
                    _seconds = minutes * 60 + seconds;
                    Navigator.pop(context);
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showFinishConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Finish Workout'),
          content: Text('Are you sure you want to finish your workout?'),
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
                _finishWorkout();
              },
            ),
          ],
        );
      },
    );
  }

  void _finishWorkout() {
    // Here you would typically save the workout data
    // For now, we'll just print a message
    print('Workout finished. Duration: ${_formatTime(_seconds)}');

    // Call the onFinish callback if provided
    widget.onFinish?.call();

    // Navigate back to the homepage
    Navigator.of(context).pushReplacementNamed('/'); // Assuming '/' is your homepage route
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Timer moved to the left
          Row(
            children: [
              GestureDetector(
                onTap: widget.isWorkoutTimer ? null : _showTimerOptions,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    _formatTime(_seconds),
                    style: TextStyle(
                      color: widget.isWorkoutTimer ? Colors.white : (_isRunning ? Colors.red : Colors.white),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (widget.isWorkoutTimer)
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      if (_isRunning) {
                        _stopTimer();
                      } else {
                        _startTimer();
                      }
                    });
                  },
                ),
              if (!widget.isWorkoutTimer) ...[
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      if (_isRunning) {
                        _stopTimer();
                      } else {
                        _startTimer();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  color: Colors.white,
                  onPressed: () {
                    _resetTimer();
                    widget.onComplete?.call();
                  },
                ),
              ],
            ],
          ),
          // Finish button added to the right
          if (widget.isWorkoutTimer)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: _showFinishConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Finish'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

