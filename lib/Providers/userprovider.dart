import 'package:flutter/foundation.dart';
import 'package:edu_app/Models/getuser.dart';

import '../Databases/services.dart'; // Import your GetUser model

class UserProvider with ChangeNotifier {
  List<GetUser> _users = [];

  List<GetUser> get users => _users;

  Future<void> fetchUsers(String userId) async {
    try {
      _users =
          await getUsers(userId); // Assuming UserService.getUsers() returns List<GetUser>
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      } // Handle or log the error as needed
    }
  }
}
