import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_todo_app_getx/app/core/utils/extensions.dart';
import 'package:flutter_todo_app_getx/app/modules/details/widget/doing_list.dart';
import 'package:flutter_todo_app_getx/app/modules/details/widget/done_list.dart';
import 'package:flutter_todo_app_getx/app/modules/home/controller.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    //converting color
    String colorString = task.color;
    String colorPlus = '0x$colorString';
    int finalColor = int.parse(colorPlus);
    //converting color
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
              child: Row(
                children: [
                  Icon(
                    IconData(task.icon, fontFamily: 'MaterialIcons'),
                    color: Color(finalColor),
                  ),
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  Text(
                    task.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                  )
                ],
              ),
            ),
            Obx(() {
              var totalTodos =
                  homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
              return Row(

                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16.0.wp, top: 3.0.wp, right: 16.0.wp),
                    child: Text(
                      '$totalTodos ' 'Tasks',
                      style: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 5.0.wp,
                  ),
                  StepProgressIndicator(
                    totalSteps: totalTodos == 0 ? 1 : totalTodos,
                    currentStep: homeCtrl.doneTodos.length,
                    size: 6,
                    padding: 0,
                    selectedGradientColor: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(finalColor), Color(finalColor)]),
                    unselectedGradientColor: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[300]!, Colors.grey.shade300]),
                  )
                ],
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
              child: TextFormField(
                controller: homeCtrl.editCtrl,
                autofocus: true,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    prefixIcon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey.shade400,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            var success =
                                homeCtrl.addTodo(homeCtrl.editCtrl.text);
                            if (success) {
                              EasyLoading.showSuccess('Todo item add success !');
                            } else {
                              EasyLoading.showError('Todo item already exist !');
                            }
                            homeCtrl.editCtrl.clear();
                          }
                        },
                        icon: const Icon(Icons.check))),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your todo item !';
                  }
                  return null;
                },
              ),
            ),
            DoingList(),
            DoneList()
          ],
        ),
      )),
    );
  }
}
