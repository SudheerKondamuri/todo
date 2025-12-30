import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For platform check (optional)

class Services {
  // NOTE: If using Android Emulator, use '10.0.2.2' instead of 'localhost'
  // If using iOS Simulator or Web, 'localhost' is fine.
  final String baseUrl = "http://localhost:3000/api/todo-lists"; 
  // final String baseUrl = "http://10.0.2.2:3000/api/todo-lists"; // Use this for Android Emulator

  // GET Request
  Future<List<dynamic>> getTasks() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the string response into a List immediately
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // POST Request
  Future<void> createTask(String taskTitle) async {
    final url = Uri.parse(baseUrl);
    
    // Create a Map to send as JSON
    final Map<String, dynamic> data = {
      'title': taskTitle, // Assuming your API expects a 'title' key
      'completed': false,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to create task');
    }
  }
}