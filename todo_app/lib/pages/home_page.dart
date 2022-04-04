import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_sorage.dart';
import 'package:todo_app/helper/translation_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  String title ='';
  

  @override
  void initState() {

    super.initState();
    _localStorage=locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'appBar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ).tr(),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {
            _showSearchPage();
          },
          icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty ? ListView.builder(itemBuilder: (context, index) {
        var _oankiListeElemani = _allTasks[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Icon(Icons.delete, color: Colors.grey),
              const SizedBox(width: 8),
              Text('remove_task').tr(),
            ],
          ),
          key: Key(_oankiListeElemani.id),
          onDismissed: (direction){
            _allTasks.removeAt(index);
            _localStorage.deleteTask(task: _oankiListeElemani);
            setState(() {
              
            });
          },
          child: TaskItem(task: _oankiListeElemani,notifyParent: refresh),
        );
      },
      itemCount: _allTasks.length,)
      : Center(child: Text('empty_task_list').tr(),)
    );
  }

refresh() {
  setState(() {});
}

  void _showAddTaskBottomSheet() {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: Form(

            child: Wrap(
              children: [
               TextFormField(
                autofocus: true,
                style: const TextStyle(fontSize: 24),       
                decoration: InputDecoration(
                  hintText: 'add_title'.tr(),
                  border: OutlineInputBorder(),  
                ),
                onChanged: (value){
                  title = value;
                },
              ),
              TextFormField( 
                  autofocus: true,
                  style: const TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    hintText: 'add_subtitle'.tr(),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (subtitle) {
                    Navigator.of(context).pop();
                    DatePicker.showTimePicker(
                      context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false, onConfirm:(time) async {
                        var yeniEklenecekGorev = Task.create(name: title, subtitle: subtitle, createdAt: time);
                        
                        _allTasks.insert(0, yeniEklenecekGorev);
                        await _localStorage.addTask(task: yeniEklenecekGorev);
                        setState(() {           
                        });
                      });
                  },
                ),
            ],
                  ),
          ),
      );
    }
  );
}

  void _getAllTaskFromDb() async{
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }

  void _showSearchPage() async{
    await showSearch(
      context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDb();
  }
}
