import 'package:flutter/material.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class Task {
  String title;
  bool completed;

  Task({
    required this.title,
    this.completed = false,
  });
}

class _DashboardScreenState extends State<DashboardScreen> {
  final taskController = TextEditingController();

  final List<Task> tasks = [];

  void addTask() {
    if (taskController.text.trim().isEmpty) return;

    setState(() {
      tasks.add(
        Task(title: taskController.text.trim()),
      );
    });

    taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    int completed =
        tasks.where((task) => task.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(
                  "Tasks: ${tasks.length}",
                ),
                subtitle: Text(
                  "Completed: $completed",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: addTask,
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: CheckboxListTile(
                      title: Text(tasks[index].title),
                      value: tasks[index].completed,
                      onChanged: (value) {
                        setState(() {
                          tasks[index].completed =
                              value ?? false;
                        });
                      },
                      secondary: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}