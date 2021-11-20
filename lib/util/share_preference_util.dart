import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/model/to_do.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  static final _instance = SharedPreferencesUtil._();

  static SharedPreferencesUtil get instance => _instance;

  static final _sharedPreferences = SharedPreferences.getInstance();

  final toDoKey = 'to_do_list';

  Future<bool> setToDoList(List<ToDo> toDoList) {
    return _sharedPreferences.then((value) => value.setStringList(
        toDoKey, toDoList.map((e) => jsonEncode(e.toJson())).toList()));
  }

  Future<List<ToDo>> getToDoList() {
    return _sharedPreferences
        .then((value) => value.getStringList(toDoKey) ?? [])
        .then((response) =>
            response.map((e) => ToDo.fromJson(jsonDecode(e))).toList());
  }
}
