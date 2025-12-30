import 'package:flutter/material.dart';
import 'services.dart'; // Import your Services class

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Services _services = Services();
  final TextEditingController _taskController = TextEditingController();
  
  // We store the Future in a variable so we can refresh it later
  late Future<List<dynamic>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _services.getTasks();
  }

  // Function to refresh the list after adding a task
  void _refreshTasks() {
    setState(() {
      _tasksFuture = _services.getTasks();
    });
  }

  // Function to handle the POST request
  void _handleAddTask() async {
    if (_taskController.text.isEmpty) return;

    try {
      // 1. Call the service
      await _services.createTask(_taskController.text);
      
      // 2. Clear the text field and close dialog
      _taskController.clear();
      if (mounted) Navigator.of(context).pop();

      // 3. Refresh the list to show the new item
      _refreshTasks();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Helper to show the input dialog
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _handleAddTask,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todo List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
          )
        ],
      ),
      // FutureBuilder handles the 3 states: Loading, Error, and Data
      body: FutureBuilder<List<dynamic>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tasks found."));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              // Assuming the API returns objects with 'title' or 'name'
              // Adjust 'title' based on your actual API response structure
              final title = task['title'] ?? task['name'] ?? 'Unknown Task'; 
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(title),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}