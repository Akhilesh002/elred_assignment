import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoModel {
  String? id;
  String? taskName;
  String? taskDescription;
  Timestamp? taskCompletionTime;

  ToDoModel(
      {this.id, this.taskName, this.taskDescription, this.taskCompletionTime});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    taskCompletionTime = json['taskCompletionTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['taskCompletionTime'] = taskCompletionTime;
    return data;
  }

  factory ToDoModel.fromFirestore(QueryDocumentSnapshot documentSnapshot) {
    Map<String, dynamic> d = documentSnapshot.data() as Map<String, dynamic>;
    return ToDoModel(id: documentSnapshot.id, taskName: d["taskName"], taskDescription: d["taskDesc"], taskCompletionTime: Timestamp.fromMillisecondsSinceEpoch(d["finishDate"]));
  }
}
