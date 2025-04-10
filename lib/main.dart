// Import necessary Flutter and Dart packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Main application entry point
void main() {
  runApp(const MyApp());
}

// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        // App theme configuration
        colorScheme: ColorScheme.light(
          primary: Colors.blue[200]!,
          onPrimary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
        // App bar styling
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[200],
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Floating action button styling
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[200],
          foregroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoListScreen(),
    );
  }
}

// Main screen widget with todo list functionality
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// State class for the todo list screen
class _TodoListScreenState extends State<TodoListScreen> {
  // List to store todo items
  final List<TodoItem> _todoItems = [];
  // Controllers for text input fields
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  // Shared preferences instance for local storage
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    // Initialize shared preferences and load saved items
    _initPrefs().then((_) {
      _loadTodoItems();
    });
  }

  // Initialize shared preferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Load todo items from local storage
  Future<void> _loadTodoItems() async {
    try {
      final String? jsonString = _prefs.getString('todo_items');
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        setState(() {
          _todoItems.clear();
          _todoItems.addAll(
            jsonList.map((item) => TodoItem.fromJson(item)).toList(),
          );
        });
      }
    } catch (e) {
      print('Error loading todo items: $e');
    }
  }

  // Save todo items to local storage
  Future<void> _saveTodoItems() async {
    try {
      final jsonList = _todoItems.map((item) => item.toJson()).toList();
      await _prefs.setString('todo_items', json.encode(jsonList));
    } catch (e) {
      print('Error saving todo items: $e');
    }
  }

  // Add a new todo item
  void _addTodoItem(String task) {
    if (task.trim().isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(
          title: task,
          isCompleted: false,
        ));
      });
      _textController.clear();
      _saveTodoItems();
    }
  }

  // Toggle completion status of a todo item
  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
    });
    _saveTodoItems();
  }

  // Delete a todo item
  void _deleteTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveTodoItems();
  }

  // Edit an existing todo item
  void _editTodoItem(int index) {
    _editController.text = _todoItems[index].title;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(
              hintText: 'Enter new text',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_editController.text.trim().isNotEmpty) {
                  setState(() {
                    _todoItems[index].title = _editController.text.trim();
                  });
                  Navigator.of(context).pop();
                  _saveTodoItems();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Display dialog for adding a new todo item
  Future<void> _displayAddDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          backgroundColor: Colors.white,
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter your task',
            ),
            style: const TextStyle(color: Colors.black),
            autofocus: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTodoItem(_textController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('To-Do List App'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _todoItems.isEmpty
          ? Center(
              child: Text(
                'No tasks found\nClick the + button to add one',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                final item = _todoItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: item.isCompleted ? Colors.grey[200] : Colors.blue[50],
                  child: InkWell(
                    onTap: () => _toggleTodoItem(index),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Completion status icon
                          Icon(
                            item.isCompleted
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: Colors.blue[700],
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          // Task title
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          // Edit and delete buttons
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue[700],
                            onPressed: () => _editTodoItem(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red[400],
                            onPressed: () => _deleteTodoItem(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      // Floating action button for adding new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: _displayAddDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Data model for a todo item
class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.isCompleted,
  });

  // Convert todo item to JSON for storage
  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  // Create todo item from JSON
  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        title: json['title'],
        isCompleted: json['isCompleted'],
      );
}