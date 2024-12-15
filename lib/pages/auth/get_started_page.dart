import 'package:bulkfitness/pages/first_page.dart';
import 'package:flutter/material.dart';
import '../../components/my_button.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  String _selectedSex = 'M';
  String? _selectedActivityLevel;
  final _heightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  final _goalWeightController = TextEditingController();
  double? _bmi;
  String _bmiDescription = '';

  final List<String> _activityLevels = [
    'Not Active',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active'
  ];

  @override
  void dispose() {
    _heightController.dispose();
    _currentWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  void _getStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstPage(),
      ),
    );
  }

  void _calculateBMI() {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_currentWeightController.text);

    if (height != null && weight != null && height > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      setState(() {
        _bmi = bmi;
        if (bmi < 18.5) {
          _bmiDescription = 'Underweight';
        } else if (bmi < 25) {
          _bmiDescription = 'Normal';
        } else if (bmi < 30) {
          _bmiDescription = 'Overweight';
        } else {
          _bmiDescription = 'Obese';
        }
      });
    } else {
      setState(() {
        _bmi = null;
        _bmiDescription = '';
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String suffix) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffix: Text(
                  suffix,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              onChanged: (_) => _calculateBMI(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Bulk!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Sex'),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _selectedSex = 'M'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedSex == 'M'
                                          ? Colors.white
                                          : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        color: _selectedSex == 'M'
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedSex = 'F'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedSex == 'F'
                                          ? Colors.white
                                          : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'F',
                                      style: TextStyle(
                                        color: _selectedSex == 'F'
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Current Height'),
                          const SizedBox(height: 4),
                          _buildTextField(_heightController, 'cm'),
                          const SizedBox(height: 16),

                          _buildLabel('Current Weight'),
                          const SizedBox(height: 4),
                          _buildTextField(_currentWeightController, 'kg'),
                          const SizedBox(height: 16),

                          _buildLabel('Goal Weight'),
                          const SizedBox(height: 4),
                          _buildTextField(_goalWeightController, 'kg'),
                          const SizedBox(height: 16),

                          _buildLabel('Activity Level'),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[800]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedActivityLevel,
                              hint: Text(
                                'Select',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              isExpanded: true,
                              dropdownColor: Colors.grey[900],
                              underline: Container(),
                              style: const TextStyle(color: Colors.white),
                              items: _activityLevels
                                  .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedActivityLevel = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // BMI Display
                          if (_bmi != null)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your BMI: ${_bmi!.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Category: $_bmiDescription',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
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

                  MyButton(
                    onTap: _getStarted,
                    text: "GET STARTED",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}