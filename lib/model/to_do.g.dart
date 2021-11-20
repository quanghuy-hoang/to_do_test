// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ToDo _$$_ToDoFromJson(Map<String, dynamic> json) => _$_ToDo(
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDone: json['isDone'] as bool? ?? false,
      task: json['task'] as String,
    );

Map<String, dynamic> _$$_ToDoToJson(_$_ToDo instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'isDone': instance.isDone,
      'task': instance.task,
    };
