import 'dart:convert';

import 'package:flutter_todo_app_getx/app/core/utils/keys.dart';
import 'package:flutter_todo_app_getx/app/data/models/tasks.dart';
import 'package:flutter_todo_app_getx/app/data/service/storage/services.dart';
import 'package:get/get.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }

  void writeTask(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
