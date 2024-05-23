import 'package:edu_app/Models/gettrash.dart';
import 'package:flutter/foundation.dart';
import '../Databases/services.dart'; // Import your GetFolders model

class TrashProvider with ChangeNotifier {
  List<GetTrash> _trash = [];

  List<GetTrash> get trash => _trash;

  Future<void> fetchtrash(trash) async {
    try {
      _trash = await getTrash(
          trash); // Assuming UserService.GetFolderss() returns List<GetFolders>
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      } // Handle or log the error as needed
    }
  }
}
