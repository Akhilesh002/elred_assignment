import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/main.dart';
import 'package:elred_assignment/model/to_do_model.dart';
import 'package:elred_assignment/screen/create_task.dart';
import 'package:elred_assignment/screen/widget/to_do_details_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ToDoWidget extends StatelessWidget {
  const ToDoWidget({Key? key, required this.model}) : super(key: key);

  final ToDoModel model;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        model.taskCompletionTime!.seconds * 1000);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ).paddingOnly(bottom: 4),
                Text(
                  model.taskDescription ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ).paddingOnly(bottom: 4),
                Text(
                  "Due On: ${DateFormat('dd-MM-yyyy').format(date).toString()}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () async {
              await deleteToDo(model);
              Get.snackbar("Delete ToDo", "ToDo Successfully deleted",
                  snackPosition: SnackPosition.BOTTOM);
            },
            icon: const Icon(
              Icons.delete,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteToDo(ToDoModel toDoModel) async {
    final FirebaseFirestore storage = FirebaseFirestore.instance;
    final currentUser = auth.currentUser;
    await storage
        .collection("toDo")
        .doc(currentUser?.uid ?? "")
        .collection("toDoItems")
        .doc(toDoModel.id ?? "")
        .delete();
  }
}
