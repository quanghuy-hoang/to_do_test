import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:to_do/model/to_do.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<ToDo> toDoList,
  }) = _HomeState;
}
