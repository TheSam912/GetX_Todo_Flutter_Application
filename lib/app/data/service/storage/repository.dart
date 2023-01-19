import 'package:flutter_todo_app_getx/app/data/models/tasks.dart';
import 'package:flutter_todo_app_getx/app/data/providers/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;

  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTasks();

  void writeTasks(List<Task> tasks) => taskProvider.writeTask(tasks);
}
