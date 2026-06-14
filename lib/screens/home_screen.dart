import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();

  Future<void> addTaskDialog() async {
    final titleController = TextEditingController();
    String category = "Personal";

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Task Title",
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButton<String>(
                    value: category,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "Personal",
                        child: Text("Personal"),
                      ),
                      DropdownMenuItem(
                        value: "Work",
                        child: Text("Work"),
                      ),
                      DropdownMenuItem(
                        value: "Shopping",
                        child: Text("Shopping"),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        category = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await taskService.addTask(
                    title: titleController.text,
                    category: category,
                  );
                }

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await AuthService().logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager Pro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: taskService.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs =
              snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No Tasks Yet",
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final task = docs[index];

              return CheckboxListTile(
                title: Text(task['title']),
                subtitle: Text(task['category']),
                value: task['completed'],
                onChanged: (value) {
                  taskService.toggleTask(
                    task.id,
                    value!,
                  );
                },
                secondary: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    taskService.deleteTask(
                      task.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}