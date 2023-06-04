import 'package:flutter/material.dart';

class ToDoProvider extends ChangeNotifier {

  String? _desc = "";
  String? _task = "";
  DateTime? _date = DateTime.now();

  String? get task => _task;
  String? get description => _desc;
  DateTime? get date => _date;

  void setDesc(String? desc) {
    _desc = desc;
    notifyListeners();
  }
  void setTask(String? taskName) {
    _task = taskName;
    notifyListeners();
  }
  void setDate(DateTime? date) {
    _date = date;
    notifyListeners();
  }
}