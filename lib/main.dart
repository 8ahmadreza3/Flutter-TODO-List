import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
// A widget that does not require mutable state (immutable UI elements).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Main app configuration with light blue theme, custom app bar and FAB styling
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        // Color scheme setup (white and sky blue theme)
        colorScheme: ColorScheme.light(
          primary: Colors.blue[200]!, // Sky blue for primary elements
          onPrimary: Colors.black, // Black text on primary
          surface: Colors.white, // White background
          onSurface: Colors.black, // Black text on surface
        ),
        // Enables Material 3 design system with modern UI components and animations
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
        // Floating action button styling : FAB Styles
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

// Main screen that displays the todo list
// A widget that can change its state/UI dynamically (mutable)
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// State class for the todo list screen
class _TodoListScreenState extends State<TodoListScreen> {
  // List to store all todo items
  final List<TodoItem> _todoItems = [];

  // Controllers for text fields
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  /// Adds a new item to the todo list
  void _addTodoItem(String task) {
    if (task.trim().isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(
          title: task,
          isCompleted: false,
        ));
      });
      _textController.clear();
    }
  }

  /// Toggles the completion status of an item
  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
    });
  }

  /// Deletes an item from the list
  void _deleteTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  /// Shows edit dialog for an item
  void _editTodoItem(int index) {
    _editController.text = _todoItems[index].title;
    // Shows an edit dialog with text field and save/cancel buttons for todo items
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          content: TextField(
            // Text input field with blue underline, hint text and auto-focus feature
            controller: _editController,
            // Customizes text field appearance with hint, borders and focus effects
            decoration: const InputDecoration(
              hintText: 'Enter new text',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Colors.black),
            autofocus: true,
          ),
          actions: [
            // Simple text button that closes the dialog when pressed (cancel action)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            // Elevated button that saves edited text and closes dialog if text is valid
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
              ),
              onPressed: () {
                if (_editController.text.trim().isNotEmpty) {
                  setState(() {
                    _todoItems[index].title = _editController.text.trim();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Shows dialog for adding a new task
  // async allows waiting for dialog interaction without blocking the app
  Future<void> _displayAddDialog() async {
    // Displays a dialog for adding new tasks with text input and action buttons
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add New Task', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          content: TextField(
            controller: _textController,
            // Customizes text field appearance with hint, borders and focus effects
            decoration: const InputDecoration(
              hintText: 'Enter your task',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Colors.black),
            autofocus: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(100), // Limit task length
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
              ),
              onPressed: () {
                _addTodoItem(_textController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main page scaffold with dynamic task list, empty state message and add button
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
              // Efficiently builds a scrollable list of todo items with interactive cards
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                final item = _todoItems[index];
                return Card(
                  // Interactive todo item card with status toggle, text and action buttons
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: item.isCompleted ? Colors.grey[200] : Colors.blue[50],
                  child: InkWell(
                    // Tappable area with ripple effect that toggles task completion status
                    onTap: () =>
                        _toggleTodoItem(index), // Toggle completion on tap
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Completion indicator
                          Icon(
                            item.isCompleted
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: Colors.blue[700],
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          // Task title
                          // Expands text to fill available space with conditional strikethrough
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
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue[700],
                            onPressed: () => _editTodoItem(index),
                          ),
                          // Delete button (trash icon)
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
      floatingActionButton: FloatingActionButton(
        onPressed: _displayAddDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Data model for a todo item
class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.isCompleted,
  });
}
