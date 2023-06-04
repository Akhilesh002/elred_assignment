import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/auth/auth.dart';
import 'package:elred_assignment/model/to_do_model.dart';
import 'package:elred_assignment/screen/create_task.dart';
import 'package:elred_assignment/screen/widget/to_do_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'widget/to_do_details_bottomsheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  RxBool showLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> taskStream = FirebaseFirestore.instance
        .collection("toDo")
        .doc(auth.currentUser?.uid)
        .collection("toDoItems")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task list"),
        actions: [
          IconButton(
            onPressed: () async {
              showLoader.value = true;
              await Auth.signOut();
              showLoader.value = false;
            },
            icon: const Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade200,
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: Get.height - kToolbarHeight,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: taskStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi ${auth.currentUser?.displayName ?? ""},",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ).paddingSymmetric(horizontal: 20),
                          if((snapshot.data?.docs ?? []).isEmpty)
                          const Text(
                            "You don't have any ToDo task, Please add first to see here",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ).paddingSymmetric(horizontal: 20),
                          const Divider(
                            thickness: 2,
                            color: Colors.white24,
                          ),
                          Flexible(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Container(
                                width: Get.width,
                                height: 2,
                                color: Colors.white24,
                              ),
                              itemBuilder: (context, index) {
                                final model = ToDoModel.fromFirestore(
                                    snapshot.data!.docs[index]);

                                return InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      ToDoDetailsBottomSheet(
                                        model: model,
                                      ),
                                      enableDrag: true,
                                      ignoreSafeArea: true,
                                    );
                                  },
                                  child: ToDoWidget(
                                    model: model,
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final loader = showLoader.value;
            return loader
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateTaskScreen());
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
