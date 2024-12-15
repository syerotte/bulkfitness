import 'package:bulkfitness/components/my_custom_calendar.dart';
import 'package:flutter/material.dart';
import '../../components/my_appbar.dart';
import '../../components/my_dropdown.dart';
import 'food_library_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with AutomaticKeepAliveClientMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userId;

  String? _selectedBreakfast;
  String? _selectedLunch;
  String? _selectedDinner;

  int _breakfastCalories = 0;
  int _lunchCalories = 0;
  int _dinnerCalories = 0;

  final int _goalCalories = 2200;

  List<Map<String, String>> _breakfastItems = [];
  List<Map<String, String>> _lunchItems = [];
  List<Map<String, String>> _dinnerItems = [];

  late DateTime _selectedDate;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _userId = _auth.currentUser?.uid ?? 'defaultUser';
    _loadDataForDate(_selectedDate);
  }

  Future<void> _loadDataForDate(DateTime date) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('meals')
        .doc(date.toIso8601String().split('T')[0])
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _breakfastItems = List<Map<String, String>>.from(
            (data['breakfast'] as List<dynamic>? ?? []).map((item) => Map<String, String>.from(item as Map<String, dynamic>))
        );
        _lunchItems = List<Map<String, String>>.from(
            (data['lunch'] as List<dynamic>? ?? []).map((item) => Map<String, String>.from(item as Map<String, dynamic>))
        );
        _dinnerItems = List<Map<String, String>>.from(
            (data['dinner'] as List<dynamic>? ?? []).map((item) => Map<String, String>.from(item as Map<String, dynamic>))
        );
        _updateCalories();
      });
    } else {
      setState(() {
        _breakfastItems = [];
        _lunchItems = [];
        _dinnerItems = [];
        _updateCalories();
      });
    }
  }

  Future<void> _saveDataToFirestore() async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('meals')
        .doc(_selectedDate.toIso8601String().split('T')[0])
        .set({
      'breakfast': _breakfastItems,
      'lunch': _lunchItems,
      'dinner': _dinnerItems,
    });
  }

  void _onDateChanged(DateTime newDate) {
    _saveDataToFirestore().then((_) {
      setState(() {
        _selectedDate = newDate;
        _loadDataForDate(newDate);
      });
    });
  }

  void _removeItem(String? mealType, String? itemName) {
    setState(() {
      if (mealType == 'breakfast') {
        _breakfastItems.removeWhere((item) => item['name'] == itemName);
      } else if (mealType == 'lunch') {
        _lunchItems.removeWhere((item) => item['name'] == itemName);
      } else if (mealType == 'dinner') {
        _dinnerItems.removeWhere((item) => item['name'] == itemName);
      }
      _updateCalories();
    });
    _saveDataToFirestore();
  }

  void _updateCalories() {
    _breakfastCalories = _calculateMealCalories(_breakfastItems);
    _lunchCalories = _calculateMealCalories(_lunchItems);
    _dinnerCalories = _calculateMealCalories(_dinnerItems);
  }

  int _calculateMealCalories(List<Map<String, String>> items) {
    return items.fold(0, (sum, item) {
      final calorieString = item['description']?.split(' ')[0] ?? '0';
      return sum + int.parse(calorieString);
    });
  }

  Future<void> _addFood(String mealType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodLibraryPage(mealType: mealType),
      ),
    );

    if (result != null) {
      setState(() {
        switch (mealType) {
          case 'Breakfast':
            _breakfastItems.add({
              'name': result['name'],
              'description': '${result['calories']} kcal, ${result['description']}',
            });
            break;
          case 'Lunch':
            _lunchItems.add({
              'name': result['name'],
              'description': '${result['calories']} kcal, ${result['description']}',
            });
            break;
          case 'Dinner':
            _dinnerItems.add({
              'name': result['name'],
              'description': '${result['calories']} kcal, ${result['description']}',
            });
            break;
        }
        _updateCalories();
      });
      await _saveDataToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int totalCalories = _breakfastCalories + _lunchCalories + _dinnerCalories;
    int remainingCalories = _goalCalories - totalCalories;

    return Scaffold(
      appBar: const MyAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Calorie",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          MyCustomCalendar(onDateChanged: _onDateChanged,
            initialDate: _selectedDate,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text("$totalCalories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text("Taken", style: TextStyle(fontSize: 14, color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: CircularProgressIndicator(
                        value: totalCalories / _goalCalories,
                        strokeWidth: 20,
                        backgroundColor: Colors.grey,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 115,
                      width: 115,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 20,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$_goalCalories", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text("Goal", style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 13.0),
                        child: Text("$remainingCalories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      SizedBox(height: 8),
                      Text("Remaining", style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyDropdown(
                    title: "Breakfast",
                    subtitle: "$_breakfastCalories kcal",
                    selectedValue: _selectedBreakfast,
                    items: _breakfastItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedBreakfast = value;
                      });
                    },
                    onRemove: (itemName) {
                      _removeItem('breakfast', itemName);
                    },
                    onAdd: () => _addFood('Breakfast'),
                  ),
                  MyDropdown(
                    title: "Lunch",
                    subtitle: "$_lunchCalories kcal",
                    selectedValue: _selectedLunch,
                    items: _lunchItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedLunch = value;
                      });
                    },
                    onRemove: (itemName) {
                      _removeItem('lunch', itemName);
                    },
                    onAdd: () => _addFood('Lunch'),
                  ),
                  MyDropdown(
                    title: "Dinner",
                    subtitle: "$_dinnerCalories kcal",
                    selectedValue: _selectedDinner,
                    items: _dinnerItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedDinner = value;
                      });
                    },
                    onRemove: (itemName) {
                      _removeItem('dinner', itemName);
                    },
                    onAdd: () => _addFood('Dinner'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

