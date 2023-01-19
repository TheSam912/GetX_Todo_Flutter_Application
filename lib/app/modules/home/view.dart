import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_todo_app_getx/app/core/utils/extensions.dart';
import 'package:flutter_todo_app_getx/app/data/models/tasks.dart';
import 'package:flutter_todo_app_getx/app/modules/home/controller.dart';
import 'package:flutter_todo_app_getx/app/modules/home/widgets/add_cart.dart';
import 'package:flutter_todo_app_getx/app/modules/home/widgets/add_dialog.dart';
import 'package:flutter_todo_app_getx/app/modules/home/widgets/task_cart.dart';
import 'package:flutter_todo_app_getx/app/report/report_view.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: [
          SafeArea(
              child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.wp),
                child: Text(
                  'My List',
                  style:
                      TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(
                () => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ...controller.tasks
                        .map((element) => LongPressDraggable(
                            data: element,
                            onDragStarted: () =>
                                controller.changeDeleting(true),
                            onDraggableCanceled: (_, __) =>
                                controller.changeDeleting(false),
                            onDragEnd: (_) => controller.changeDeleting(false),
                            feedback: Opacity(
                              opacity: 0.8,
                              child: TaskCart(task: element),
                            ),
                            child: TaskCart(task: element)))
                        .toList(),
                    AddCard()
                  ],
                ),
              )
            ],
          )),
          ReportPage()
        ]),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(() => FloatingActionButton(
                backgroundColor:
                    controller.deleting.value ? Colors.red : Colors.blue,
                onPressed: () {
                  if (controller.tasks.isNotEmpty) {
                    Get.to(AddDialog(), transition: Transition.downToUp);
                  } else {
                    EasyLoading.showError('Please create your task type !');
                  }
                },
                child:
                    Icon(controller.deleting.value ? Icons.delete : Icons.add),
              ));
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Deleting success');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: Obx(
          () =>  BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Padding(
                    padding: EdgeInsets.only(right: 15.0.wp),
                    child: const Icon(Icons.apps),
                  )),
              BottomNavigationBarItem(
                  label: 'Report',
                  icon: Padding(
                    padding: EdgeInsets.only(left: 15.0.wp),
                    child: const Icon(Icons.data_usage),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
