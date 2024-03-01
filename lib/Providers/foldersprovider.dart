import 'package:flutter/foundation.dart';
import 'package:edu_app/Models/getfolders.dart';
import '../Databases/services.dart'; // Import your GetFolders model

class FolderProvider with ChangeNotifier {
  List<GetFolders> _folders = [];

  List<GetFolders> get folders => _folders;

  Future<void> fetchFolders(userID) async {
    try {
      _folders = await getFolders(
          userID); // Assuming UserService.GetFolderss() returns List<GetFolders>
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      } // Handle or log the error as needed
    }
  }
}
