import 'package:flutter/foundation.dart';

export 'package:flutter/foundation.dart';

export 'globals.dart';

class ArrayProvider extends ChangeNotifier {
  List<String> _myArray = [
    'someshit so seriously awesome that I cant state how stoked I am. Like what the fuck and oh my god',
    'some another thing',
    'more stuff',
  ];

  List<String> get myArray => _myArray;

  void addItem(String item) {
    // Only add if there's actual content and it's not the last added item
    if (item.isNotEmpty && (_myArray.isEmpty || _myArray.last != item)) {
      _myArray.add(item);
      notifyListeners();
    }
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final temp = _myArray.removeAt(oldIndex);
    _myArray.insert(newIndex, temp);
    notifyListeners();
  }
}
