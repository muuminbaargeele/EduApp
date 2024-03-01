import 'package:flutter/foundation.dart';
import 'package:edu_app/Models/getnotes.dart';
import '../Databases/services.dart'; // Import your GetFolders model

class NotesProvider with ChangeNotifier {
  List<GetNotes> _notes = [];

  List<GetNotes> get notes => _notes;

  Future<void> fetchNotes(folderId) async {
    try {
      _notes = await getNotes(
          folderId); // Assuming UserService.GetFolderss() returns List<GetFolders>
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      } // Handle or log the error as needed
    }
  }
}
