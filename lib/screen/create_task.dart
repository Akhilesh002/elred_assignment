import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/model/to_do_model.dart';
import 'package:elred_assignment/provider/to_do_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key, this.model}) : super(key: key);

  final ToDoModel? model;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  DateTime selectedDate = DateTime.now();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final showLoader = false.obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.model != null) {
        nameController.text = widget.model?.taskName ?? "";
        Provider.of<ToDoProvider>(context, listen: false)
            .setTask(nameController.text);
        descController.text = widget.model?.taskDescription ?? "";
        Provider.of<ToDoProvider>(context, listen: false)
            .setDesc(descController.text);
        selectedDate = DateTime.fromMillisecondsSinceEpoch(
            widget.model!.taskCompletionTime!.seconds * 1000);
        setState(() {
          Provider.of<ToDoProvider>(context, listen: false)
              .setDate(selectedDate);
          dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate).toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model != null ? "Edit To Do" : "Add To Do"),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,
                      hintText: "Task"),
                  onChanged: (str) {
                    Provider.of<ToDoProvider>(context, listen: false).setTask(str);
                    // t.setTask(str!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,
                      hintText: "Description"),
                  onChanged: (str) {
                    Provider.of<ToDoProvider>(context, listen: false).setDesc(str);
                    // t.setDesc(str!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,
                      hintText: "Due Date"),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.model != null) {
                      await updateToDo();
                    } else {
                      await addToDo(context);
                    }
                  },
                  child: Text(widget.model != null ? "Update" : "Save"),
                )
              ],
            ),
          ),
          Obx(() {
            final loader = showLoader.value;
            return loader
                ? const Center(child: CircularProgressIndicator(),)
                : const SizedBox.shrink();
          })

        ],
      ),
    );
  }

  Future<void> updateToDo() async {
    showLoader.value = true;
    final uuid = FirebaseAuth.instance.currentUser?.uid;

    if (widget.model != null) {
      final documentId = widget.model?.id;

      final storage = FirebaseFirestore.instance;
      final ref = storage.collection("toDo");

      final task = Provider.of<ToDoProvider>(context, listen: false).task;
      final desc =
          Provider.of<ToDoProvider>(context, listen: false).description;
      final date = Provider.of<ToDoProvider>(context, listen: false)
          .date
          ?.millisecondsSinceEpoch;

      await ref.doc(uuid).collection("toDoItems").doc(documentId).update({
        "taskName": task ?? "",
        "taskDesc": desc ?? "",
        "finishDate": date ?? Timestamp.now().millisecondsSinceEpoch,
      });
      showLoader.value = false;
      Get..back()..back();
      Get.snackbar("ToDo Update", "ToDo updated successfully",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addToDo(BuildContext context) async {
    showLoader.value = true;
    final uuid = FirebaseAuth.instance.currentUser?.uid;

    bool idPresent = false;
    final task = Provider.of<ToDoProvider>(context, listen: false).task;
    final desc = Provider.of<ToDoProvider>(context, listen: false).description;
    final date = Provider.of<ToDoProvider>(context, listen: false)
        .date
        ?.millisecondsSinceEpoch;

    final storage = FirebaseFirestore.instance;
    final ref = storage.collection("toDo");

    final toDoRef = (await ref.get()).docs;
    for (var element in toDoRef) {
      if (element.id == uuid) {
        idPresent = true;
        break;
      }
    }
    if (idPresent) {
      await ref.doc(uuid).update({
        "taskName": task,
        "taskDesc": desc,
        "finishDate": date,
      });
    } else {
      await ref.doc(uuid).collection("toDoItems").add({
        "taskName": task,
        "taskDesc": desc,
        "finishDate": date,
      });
    }
    showLoader.value = false;
    Get.back();
    Get.snackbar("ToDo Added", "ToDo added successfully",
        snackPosition: SnackPosition.BOTTOM);

    if (mounted) {
      Provider.of<ToDoProvider>(context, listen: false).setTask(null);
      Provider.of<ToDoProvider>(context, listen: false).setDesc(null);
      Provider.of<ToDoProvider>(context, listen: false).setDate(null);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(now.year, now.month, now.day),
        lastDate: DateTime(now.year + 10));
    if (picked != null && picked != selectedDate && context.mounted) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate).toString();
      });
      Provider.of<ToDoProvider>(context, listen: false).setDate(picked);
    }
  }
}
