import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/to_do_model.dart';
import '../create_task.dart';

class ToDoDetailsBottomSheet extends StatelessWidget {
  const ToDoDetailsBottomSheet({Key? key, required this.model})
      : super(key: key);

  final ToDoModel model;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.taskName ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.taskDescription ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          textAlign: TextAlign.end,
                          "Due On: ${DateFormat('dd-MM-yyyy')
                              .format(DateTime.fromMillisecondsSinceEpoch(model
                              .taskCompletionTime
                              ?.millisecondsSinceEpoch ??
                              0))
                              .toString()}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.to(
                            () => CreateTaskScreen(
                              model: model,
                            ),
                          );
                        },
                        child: const Text("Edit"),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
