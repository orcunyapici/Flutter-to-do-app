import 'package:flutter/material.dart';
import 'package:todo_app/data/local_sorage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  Task task;
  final Function() notifyParent;
  
  TaskItem({Key? key, required this.task, required this.notifyParent}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  // ignore: prefer_final_fields
  TextEditingController _taskNameControllerName = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _taskNameControllerSubtitle = TextEditingController();
  late LocalStorage _localStorage;
  late List<Task> _allTasks;
  

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();

    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameControllerName.text = widget.task.name;
    _taskNameControllerSubtitle.text = widget.task.subtitle;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
            ),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {

            widget.task.isCompleted = !widget.task.isCompleted;

            if (widget.task.isCompleted = true) {
              _allTasks.remove(widget.task);
              _localStorage.deleteTask(task: widget.task);
              debugPrint('silme tetiklendi');
              
              _getAllTaskFromDb();
              widget.notifyParent();
            setState(() {});
            }
          },
          child: Container(
            child: const Icon(Icons.check, color: Colors.white),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 0.8)),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              )
            : TextFormField(
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                controller: _taskNameControllerName,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    hintText: 'Başlık Giriniz', border: InputBorder.none),
                onChanged: (yeniDeger) {

                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  
                },
              ),
        subtitle: widget.task.isCompleted
            ? Text(
                widget.task.subtitle,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextFormField(
                controller: _taskNameControllerSubtitle,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Açıklama giriniz.',
                  border: InputBorder.none,
                ),
                onChanged: (deger) {
                  
                    widget.task.subtitle = deger;
                    _localStorage.updateTask(task: widget.task);
                  
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

}
