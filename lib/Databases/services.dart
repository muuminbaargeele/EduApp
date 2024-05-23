import 'package:edu_app/Models/gettrash.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:edu_app/Models/getfolders.dart';
import 'package:edu_app/Models/getnotes.dart';
import 'dart:convert';

import 'package:edu_app/Models/getuser.dart';

const String urls = "https://myendpoint.000webhostapp.com/";

// Assuming box is a local storage instance, like Hive or SharedPreferences
// Make sure to pass this object correctly to the login function

// Login API
Future<Map<String, dynamic>> login(
    String email, String password, dynamic box) async {
  const url = '$urls/eduapp/login.php'; // Replace with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'Email': email,
        'Password': password,
      },
    );

    if (response.statusCode == 200) {
      // Successful login
      final responseData = jsonDecode(response.body);
      // Process the response data as needed
      if (responseData == "Success") {
        return responseData; // Return the entire response data as Map
      } else {
        return responseData;
      }
    } else {
      // Error handling for unsuccessful login
      if (kDebugMode) {
        print('Login failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Login failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}

// Register API
Future<Map<String, dynamic>> register(
    String username, String email, String password) async {
  const url =
      '$urls/eduapp/register.php'; // Adjust with your registration API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'Username':
            username, // Ensure these field names match with your API's expected fields
        'Email': email,
        'Password': password,
      },
    );

    if (response.statusCode == 200) {
      // Successful registration
      final responseData = jsonDecode(response.body);
      // Assuming the API returns a string message on successful registration
      if (responseData == "Success") {
        return responseData;
      } else {
        // Handle specific API error messages (e.g., email already exists)
        return responseData; // Directly return the API's response message
      }
    } else {
      // Error handling for unsuccessful registration
      if (kDebugMode) {
        print('Registration failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Registration failed. Status code: ${response.statusCode}'
      };
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'};
  }
}

// OTP Check API
Future<Map<String, dynamic>> otpCheck(
  String gmail,
  String code,
) async {
  const url =
      '$urls/eduapp/checkotp.php'; // Adjust with your otpCheck API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'Email':
            gmail, // Ensure these field names match with your API's expected fields
        'Code': code,
      },
    );

    if (response.statusCode == 200) {
      // Successful otpCheck
      final responseData = jsonDecode(response.body);
      // Assuming the API returns a string message on successful otpCheck
      if (responseData == "Success") {
        return responseData;
      } else {
        // Handle specific API error messages (e.g., email already exists)
        return responseData; // Directly return the API's response message
      }
    } else {
      // Error handling for unsuccessful otpCheck
      if (kDebugMode) {
        print('otpCheck failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'otpCheck failed. Status code: ${response.statusCode}'
      };
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'};
  }
}

// Fetch User Details API
Future<List<GetUser>> getUsers(String userId) async {
  const url = '$urls/eduapp/getuser.php'; // Adjust with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Ensure these field names match with your API's expected fields
        'UserId': userId,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // parse the JSON and return a list of GetUser objects.
      return getUserFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle error accordingly.
      if (kDebugMode) {
        print('Failed to load users. Status code: ${response.statusCode}');
      }
      throw Exception('Failed to load users');
    }
  } catch (error) {
    // Handle exceptions from the HTTP request.
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    throw Exception('An error occurred while fetching users: $error');
  }
}

// Fetch Folders API
Future<List<GetFolders>> getFolders(userID) async {
  const url = '$urls/eduapp/getfolders.php'; // Adjust with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Ensure these field names match with your API's expected fields
        'UserID': userID,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // parse the JSON and return a list of GetUser objects.
      return getFoldersFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle error accordingly.
      if (kDebugMode) {
        print('Failed to load Folders. Status code: ${response.statusCode}');
      }
      throw Exception('Failed to load Folders');
    }
  } catch (error) {
    // Handle exceptions from the HTTP request.
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    throw Exception('An error occurred while fetching Folders: $error');
  }
}

// Fetch Notes API
Future<List<GetNotes>> getNotes(folderId) async {
  const url = '$urls/eduapp/getnotes.php'; // Adjust with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Ensure these field names match with your API's expected fields
        'FolderId': folderId,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // parse the JSON and return a list of GetUser objects.
      return getNotesFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle error accordingly.
      if (kDebugMode) {
        print('Failed to load Notes. Status code: ${response.statusCode}');
      }
      throw Exception('Failed to load Notes');
    }
  } catch (error) {
    // Handle exceptions from the HTTP request.
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    throw Exception('An error occurred while fetching Notes: $error');
  }
}

// Fetch Trash API
Future<List<GetTrash>> getTrash(trash) async {
  const url = '$urls/eduapp/getnotes.php'; // Adjust with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Ensure these field names match with your API's expected fields
        'Trash': trash.toString(),
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // parse the JSON and return a list of GetUser objects.
      return getTrashFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle error accordingly.
      if (kDebugMode) {
        print('Failed to load Notes. Status code: ${response.statusCode}');
      }
      throw Exception('Failed to load Notes');
    }
  } catch (error) {
    // Handle exceptions from the HTTP request.
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    throw Exception('An error occurred while fetching Notes: $error');
  }
}

// Add New Folder
Future<Map<String, dynamic>> addFolder(String folderName, String createdDate,
    String folderColor, String userId) async {
  final url =
      Uri.parse('$urls/eduapp/addfolder.php'); // Adjust with your API endpoint

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'FolderName': folderName,
        'CreatedDate': createdDate,
        'FolderColor': folderColor,
        'UserID': userId,
      },
    );

    if (response.statusCode == 200) {
      // Successful folder addition
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // You can customize the response based on your API's response structure
      // For example, if your API returns {"status": "success", "message": "Folder added successfully"}
      return responseData;
    } else {
      // Error handling for unsuccessful folder addition
      if (kDebugMode) {
        print('Add folder failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Add folder failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}

// Add New Note
Future<Map<String, dynamic>> addNote(String noteDescription, String topicName,
    String noteColor, String createdDate, String folderId) async {
  final url =
      Uri.parse('$urls/eduapp/addnote.php'); // Adjust with your API endpoint

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'NoteDescription': noteDescription,
        'TopicName': topicName,
        'NoteColor': noteColor,
        'CreatedDate': createdDate,
        'FolderId': folderId,
      },
    );

    if (response.statusCode == 200) {
      // Successful folder addition
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // You can customize the response based on your API's response structure
      // For example, if your API returns {"status": "success", "message": "Folder added successfully"}
      return responseData;
    } else {
      // Error handling for unsuccessful folder addition
      if (kDebugMode) {
        print('Add folder failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Add folder failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}

// Delete Folder
Future<Map<String, dynamic>> deleteFolder(String folderId) async {
  final url = Uri.parse(
      '$urls/eduapp/deletefolder.php'); // Adjust with your API endpoint

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'FolderId': folderId,
      },
    );

    if (response.statusCode == 200) {
      // Successful folder deleted
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // You can customize the response based on your API's response structure
      // For example, if your API returns {"status": "success", "message": "Folder added successfully"}
      return responseData;
    } else {
      // Error handling for unsuccessful folder deleted
      if (kDebugMode) {
        print('Delete folder failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Delete folder failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}

// Delete Note
Future<Map<String, dynamic>> deleteNote(
    {noteId, delete, recovery, userid}) async {
  final url =
      Uri.parse('$urls/eduapp/deletenote.php'); // Adjust with your API endpoint

  if (delete != null && userid != null) {
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'UserId': userid,
          'DeleteAll': delete,
        },
      );

      if (response.statusCode == 200) {
        // Successful Note deleted
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // You can customize the response based on your API's response structure
        // For example, if your API returns {"status": "success", "message": "Note added successfully"}
        return responseData;
      } else {
        // Error handling for unsuccessful Note deleted
        if (kDebugMode) {
          print('Delete Note failed. Status code: ${response.statusCode}');
        }
        return {
          'error': 'Delete Note failed. Status code: ${response.statusCode}'
        }; // Return an error message
      }
    } catch (error) {
      // Error handling for network request
      if (kDebugMode) {
        print('An error occurred: $error');
      }
      return {'error': 'An error occurred: $error'}; // Return an error message
    }
  } else if (noteId != null && recovery == null) {
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'NoteId': noteId,
        },
      );

      if (response.statusCode == 200) {
        // Successful Note deleted
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // You can customize the response based on your API's response structure
        // For example, if your API returns {"status": "success", "message": "Note added successfully"}
        return responseData;
      } else {
        // Error handling for unsuccessful Note deleted
        if (kDebugMode) {
          print('Delete Note failed. Status code: ${response.statusCode}');
        }
        return {
          'error': 'Delete Note failed. Status code: ${response.statusCode}'
        }; // Return an error message
      }
    } catch (error) {
      // Error handling for network request
      if (kDebugMode) {
        print('An error occurred: $error');
      }
      return {'error': 'An error occurred: $error'}; // Return an error message
    }
  } else {
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'NoteId': noteId,
          'Recovery': recovery,
        },
      );

      if (response.statusCode == 200) {
        // Successful Note deleted
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // You can customize the response based on your API's response structure
        // For example, if your API returns {"status": "success", "message": "Note added successfully"}
        return responseData;
      } else {
        // Error handling for unsuccessful Note deleted
        if (kDebugMode) {
          print('Delete Note failed. Status code: ${response.statusCode}');
        }
        return {
          'error': 'Delete Note failed. Status code: ${response.statusCode}'
        }; // Return an error message
      }
    } catch (error) {
      // Error handling for network request
      if (kDebugMode) {
        print('An error occurred: $error');
      }
      return {'error': 'An error occurred: $error'}; // Return an error message
    }
  }
}

// Update Folder
Future<Map<String, dynamic>> updateFolder(
  String userId,
  String folderId,
  String folderName,
  String folderColor,
) async {
  final url = Uri.parse(
      '$urls/eduapp/updatefolder.php'); // Adjust with your API endpoint

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'UserId': userId,
        'FolderId': folderId,
        'FolderName': folderName,
        'FolderColor': folderColor,
      },
    );

    if (response.statusCode == 200) {
      // Successful folder updated
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // You can customize the response based on your API's response structure
      // For example, if your API returns {"status": "success", "message": "Folder added successfully"}
      return responseData;
    } else {
      // Error handling for unsuccessful folder updated
      if (kDebugMode) {
        print('Update folder failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Update folder failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}

// Update Note
Future<Map<String, dynamic>> updateNote(
  String noteDescription,
  String topicName,
  String noteColor,
  String noteId,
) async {
  final url =
      Uri.parse('$urls/eduapp/updatenote.php'); // Adjust with your API endpoint

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'NoteDescription': noteDescription,
        'TopicName': topicName,
        'NoteColor': noteColor,
        'NoteId': noteId,
      },
    );

    if (response.statusCode == 200) {
      // Successful folder updated
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // You can customize the response based on your API's response structure
      // For example, if your API returns {"status": "success", "message": "Folder added successfully"}
      return responseData;
    } else {
      // Error handling for unsuccessful folder updated
      if (kDebugMode) {
        print('Update folder failed. Status code: ${response.statusCode}');
      }
      return {
        'error': 'Update folder failed. Status code: ${response.statusCode}'
      }; // Return an error message
    }
  } catch (error) {
    // Error handling for network request
    if (kDebugMode) {
      print('An error occurred: $error');
    }
    return {'error': 'An error occurred: $error'}; // Return an error message
  }
}
