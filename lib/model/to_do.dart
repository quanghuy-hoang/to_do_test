import 'package:freezed_annotation/freezed_annotation.dart';

part 'to_do.freezed.dart';
part 'to_do.g.dart';

@freezed
class ToDo with _$ToDo {
  const factory ToDo({
    required DateTime createdAt,
    @Default(false) bool isDone,
    required String task,
  }) = _ToDo;

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);
}
