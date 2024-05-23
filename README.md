To-Do List
This is a to-do list application built with Flutter. The app allows users to add, edit, delete tasks. It also saves the to-do list locally using SharedPreferences, so your tasks persist between sessions.

**Features**
Add new tasks
Edit existing tasks
Delete tasks
Mark tasks as completed
Persist tasks locally


**Getting Started**
*Prerequisites*

Flutter SDK: Installation Guide
A suitable IDE (e.g., Android Studio, VS Code) with Flutter and Dart plugins installed

Install the required dependencies:
flutter pub get

Run the app:
flutter run

Code Overview
main.dart
The entry point of the application. It sets up the main structure and theme of the app.

TodoListScreen
A StatefulWidget that displays the list of to-dos. It handles loading, saving, adding, editing, and deleting tasks.

*Key Methods:*
_loadTodos(): Loads the to-do list from SharedPreferences.
_saveTodos(): Saves the to-do list to SharedPreferences.
_addTodo(): Displays a dialog to add a new task.
_editTodoAt(int index): Displays a dialog to edit an existing task.
_removeTodoAt(int index): Removes a task from the list.
_toggleTodoCompleted(int index): Toggles the completed status of a task.

![image](https://github.com/AyushDave32/PRODIGY_AD_02/assets/72338309/d8992960-8f5a-414a-bf1b-ec7255bf6182)

![image](https://github.com/AyushDave32/PRODIGY_AD_02/assets/72338309/cc499f9c-80aa-49b4-a045-5fd3078288c9)

***Dependencies***
Flutter
SharedPreferences

*Contributing*
If you wish to contribute to this project, please follow these steps:

1)Fork the repository.
2)Create a new branch (git checkout -b feature-branch).
3)Make your changes.
4)Commit your changes (git commit -am 'Add new feature').
5)Push to the branch (git push origin feature-branch).
6)Create a new Pull Request.

*License*
This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
Thanks to the Flutter community for their excellent resources and support.
