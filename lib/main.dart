import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Add this import for JSON encoding/decoding

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, Object>> _todos =
      []; // Use Map<String, Object> for consistency

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      setState(() {
        _todos = (jsonDecode(todosString) as List)
            .map((item) => item as Map<String, Object>)
            .toList();
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString = jsonEncode(_todos);
    prefs.setString('todos', todosString);
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTodo = "";
        return AlertDialog(
          title: Text("Add a new To-Do"),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (newTodo.isNotEmpty) {
                    _todos.add({'title': newTodo, 'completed': false});
                    _saveTodos();
                    Navigator.pop(context);
                  }
                });
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editTodoAt(int index) {
    TextEditingController controller =
        TextEditingController(text: _todos[index]['title'] as String);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit To-Do"),
          content: TextField(
            controller: controller,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (controller.text.isNotEmpty) {
                    _todos[index]['title'] = controller.text;
                    _saveTodos();
                    Navigator.pop(context);
                  }
                });
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _removeTodoAt(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }

  void _toggleTodoCompleted(int index) {
    setState(() {
      _todos[index]['completed'] = !(_todos[index]['completed'] as bool);
      _saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task-2 To-Do List"),
        backgroundColor: Colors.teal,
      ),
      body: _todos.isEmpty
          ? Center(
              child: Text(
                "No To-Dos yet!",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_todos[index]['title'] as String),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _removeTodoAt(index);
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Checkbox(
                        value: _todos[index]['completed'] as bool,
                        onChanged: (bool? value) {
                          _toggleTodoCompleted(index);
                        },
                      ),
                      title: Text(
                        _todos[index]['title'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: (_todos[index]['completed'] as bool)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editTodoAt(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeTodoAt(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }
}
