import 'package:flutter/foundation.dart';

import '../models/categoeri.dart';
import '../utility/json_loader.dart';

class CategoeriesProvider with ChangeNotifier {
  List<Categoeries> _categoeriess = [];

  List<Categoeries> get categoeriess {
    return [..._categoeriess];
  }

  Future<void> loadCategoeriess() async {
    print("Categoeriess.....categoeriesProvider...");

    try {
      final jsonLoader = JsonLoader();
      _categoeriess =
          await jsonLoader.loadCategoriesFromJson('assets/categories_data.json');
      print("Categoeriess........${_categoeriess}");
      notifyListeners();
    } catch (error) {
      // Handle error
      print("Error loading pv Categoeriess: $error");

    }
  }

  Categoeries findById(String id) {
    return _categoeriess.firstWhere((categoeries) => categoeries.id == id);
  }
}
