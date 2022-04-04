import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{

  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String subtitle;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.subtitle,
      required this.createdAt,
      required this.isCompleted});

  factory Task.create({required name, required createdAt, subtitle}) {
    return Task(
        id: Uuid().v1(), name: name,subtitle: subtitle, createdAt: createdAt, isCompleted: false);
  }
}
