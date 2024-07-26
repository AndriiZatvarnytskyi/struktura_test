import 'package:flutter/material.dart';

import '../domain/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final List<Task> _tasks = [];
  int _taskIdCounter = 1;

  @override
  void initState() {
    super.initState();
    _addTasks(5);
  }

  void _addTasks(int count) {
    for (int i = 0; i < count; i++) {
      final task = Task(_taskIdCounter++, _updateTask);
      _tasks.add(task);
      task.start();
    }
  }

  void _repeat() {
    if (_tasks.every((element) => element.isComplete)) {
      _tasks.clear();
      _taskIdCounter = 1;
      _addTasks(5);
    } else {
      scaffoldMesseg(
        text: 'Some tasks is not complated',
      );
    }
  }

  void _addMoreTasks() {
    setState(() {
      _addTasks(1);
    });
  }

  void _updateTask() {
    setState(() {});
  }

  void scaffoldMesseg({
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_tasks.every((element) => element.isComplete)
            ? 'All tasks complete'
            : 'Please wait'),
        leading: IconButton(
          icon: const Icon(Icons.replay_outlined),
          onPressed: _repeat,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMoreTasks,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.status),
            trailing: task.isRunning ? const CircularProgressIndicator() : null,
          );
        },
      ),
    );
  }
}
