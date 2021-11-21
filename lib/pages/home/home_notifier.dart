import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:to_do/model/to_do.dart';
import 'package:to_do/repository/share_preference_util.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier.withInitialState(HomeState initialState) : super(initialState);

  HomeNotifier() : super(const HomeState()) {
    init();
  }

  Future<void> init() {
    return SharedPreferencesUtil.instance
        .getToDoList()
        .then((toDoList) => state = state.copyWith(toDoList: toDoList));
  }

  void addToDo(String task, {bool isDone = false, DateTime? createdAt}) {
    final toDoList = state.toDoList.toList();
    final toDo = ToDo(
        createdAt: createdAt ?? DateTime.now(), task: task, isDone: isDone);
    toDoList.add(toDo);
    state = state.copyWith(toDoList: toDoList);
    SharedPreferencesUtil.instance.setToDoList(toDoList);
  }

  void removeToDo(DateTime createdAt) {
    final toDoList = state.toDoList.toList();
    toDoList.removeWhere((element) => element.createdAt == createdAt);
    state = state.copyWith(toDoList: toDoList);
    SharedPreferencesUtil.instance.setToDoList(toDoList);
  }

  void editToDoTask(ToDo oldToDo, String newTask) {
    final toDoList = state.toDoList.toList();
    final toDoIndex = toDoList.indexOf(oldToDo);
    if (toDoIndex == -1) return;
    toDoList[toDoIndex] = toDoList[toDoIndex].copyWith(task: newTask);
    state = state.copyWith(toDoList: toDoList);
    SharedPreferencesUtil.instance.setToDoList(toDoList);
  }

  void toggleToDoStatus(ToDo oldToDo, bool isDone) {
    final toDoList = state.toDoList.toList();
    final toDoIndex = toDoList.indexOf(oldToDo);
    if (toDoIndex == -1) return;
    toDoList[toDoIndex] = toDoList[toDoIndex].copyWith(isDone: isDone);
    state = state.copyWith(toDoList: toDoList);
    SharedPreferencesUtil.instance.setToDoList(toDoList);
  }
}
