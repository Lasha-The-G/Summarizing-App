// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
// export 'globals.dart';

class globals extends ChangeNotifier {
  final _storage = Hive.box('storage');

  //

  double _summaryLength = 50.0;

  Map<String, String> _computedText = {
    "transcript": """transcript from globals file""",
    "summary": """summary from globals file""",
    "formated": """formated from globals file""",
  };

  List<String> _myArray = [
    'Temporary Note',
  ];

  double get summaryLength => _summaryLength;

  Map<String, String> get computedText => _computedText;

  List<String> get myArray => _myArray;

  //

  globals() {
    _loadFromStorage();
  }

  // clearStorage(); // Oh my god
  void _loadFromStorage() {
    if (_storage.containsKey('summaryLen')) {
      _summaryLength = _storage.get('summaryLen');
    }
    if (_storage.containsKey('computedText')) {
      final Map tempText = _storage.get('computedText');
      _computedText = Map<String, String>.from(tempText);
    }
    if (_storage.containsKey('notes')) {
      final List tempNotes = _storage.get('notes');
      _myArray = List<String>.from(tempNotes);
    }
  }

  void saveToStorage() {
    _storage.put('summaryLen', _summaryLength);
    _storage.put('computedText', _computedText);
    _storage.put('notes', _myArray);
  }

  void clearStorage() {
    _storage.deleteAll(_storage.keys);
    print("deleted everything");
  }

  //
  //

  void updateSummaryLength(double newLength) {
    _summaryLength = newLength;
    saveToStorage();
    notifyListeners();
  }

  void addItem(String item) {
    if (item.isNotEmpty && (_myArray.isEmpty || _myArray.last != item)) {
      _myArray.add(item);
      saveToStorage();
      notifyListeners();
    }
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final temp = _myArray.removeAt(oldIndex);
    _myArray.insert(newIndex, temp);
    saveToStorage();
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _myArray.length) {
      _myArray.removeAt(index);
      saveToStorage();
      notifyListeners();
    }
  }
}
