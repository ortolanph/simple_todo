import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Todo with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String task;
  @HiveField(2, defaultValue: false)
  bool done;

  Todo({
    required this.id,
    required this.task,
    required this.done,
  });

  Todo copyWith({bool? done}) {
    return Todo(
      id: id,
      task: task,
      done: done ?? this.done,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  List<Object?> get props => [id, task, done];

  @override
  bool get stringify => true;
}
