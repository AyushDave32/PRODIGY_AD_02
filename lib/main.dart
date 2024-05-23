import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, dynamic>> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todos = (prefs.getStringList('todos') ?? []).map((item) {
        List<String> splitItem = item.split('##');
        return {'title': splitItem[0], 'completed': splitItem[1] == 'true'};
      }).toList();
    });
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'todos',
        _todos
            .map((item) => '${item['title']}##${item['completed']}')
            .toList());
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
        TextEditingController(text: _todos[index]['title']);
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
      _todos[index]['completed'] = !_todos[index]['completed'];
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
                  key: Key(_todos[index]['title']),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _removeTodoAt(index);
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Checkbox(
                        value: _todos[index]['completed'],
                        onChanged: (bool? value) {
                          _toggleTodoCompleted(index);
                        },
                      ),
                      title: Text(
                        _todos[index]['title'],
                        style: TextStyle(
                          fontSize: 18,
                          decoration: _todos[index]['completed']
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
