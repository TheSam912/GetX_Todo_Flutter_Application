import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_todo_app_getx/app/core/utils/extensions.dart';
import 'package:flutter_todo_app_getx/app/data/models/tasks.dart';
import 'package:flutter_todo_app_getx/app/modules/home/controller.dart';
import 'package:get/get.dart';
import 'package:flutter_todo_app_getx/app/core/value/icons.dart';
import 'package:dotted_border/dotted_border.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.sp),
              radius: 5,
              title: 'Task Type',
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        controller: homeCtrl.editCtrl,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your task title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                      child: Wrap(
                        spacing: 2.0.wp,
                        children: icons
                            .map((e) => Obx(() {
                                  final index = icons.indexOf(e);
                                  return ChoiceChip(
                                    label: e,
                                    selectedColor: Colors.blue.shade100,
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    selected: homeCtrl.chipIndex.value == index,
                                    onSelected: (bool selected) {
                                      homeCtrl.chipIndex.value =
                                          selected ? index : 0;
                                    },
                                  );
                                }))
                            .toList(),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            //Convert IconData to int
                            IconData thisIcon =
                                icons[homeCtrl.chipIndex.value].icon;
                            int finalIcon = thisIcon.codePoint;
                            int icon = finalIcon;
                            //Convert IconData to int

                            //Convert materialColor to hex as String
                            Color thisColor =
                                icons[homeCtrl.chipIndex.value].color;
                            final hexColor = thisColor.value.toRadixString(16);
                            String color = hexColor;
                            //Convert materialColor to hex as String

                            var task = Task(
                                title: homeCtrl.editCtrl.text,
                                icon: icon,
                                color: color);
                            Get.back();
                            homeCtrl.addTask(task)
                                ? EasyLoading.showSuccess('Create success !')
                                : EasyLoading.showError('Duplicated task !');
                          }
                        },
                        child: const Text('Confirm'))
                  ],
                ),
              ));

          homeCtrl.editCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          dashPattern: const [8, 4],
          color: Colors.grey.shade400,
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     return int.parse(hexColor, radix: 16);
//   }
//
//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }
