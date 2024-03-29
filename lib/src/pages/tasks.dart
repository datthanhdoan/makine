// Thêm các thư viện cần thiết
import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
part 'tasks.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dueDate;

  @HiveField(2)
  bool isDone;

  Task({
    required this.title,
    required this.dueDate,
    this.isDone = false,
  });
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

// Thêm task
class _TaskPageState extends State<TaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        setState(() {
          _dueDate = date;
        });
      },
      currentTime: _dueDate,
      locale: LocaleType.en,
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text,
        dueDate: _dueDate,
        isDone: false,
      );
      // Lưu task vào Hive
      final taskBox = Hive.box<Task>('tasks');
      taskBox.add(task);
      Navigator.pop(context, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: ui.Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 13,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/MainBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "Add New Note",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ui.Color.fromARGB(255, 233, 233, 233),
                            shadows: [
                              Shadow(
                                color: ui.Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.9),
                                offset: Offset(0, 0),
                                blurRadius: 25,
                              ),
                            ],
                            fontFamily: 'Quicksand'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon(
                  //   Icons.calendar_today,
                  //   color: Color.fromARGB(255, 37, 76, 73),
                  // ),
                  SizedBox(width: 96.0),
                  Text(
                    DateFormat('dd MMM yyyy').format(_dueDate),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: Icon(Icons.calendar_month_outlined),
                  )
                ],
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
                autofocus: false,
                maxLines: 14,
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 14,
                    ),
                cursorColor: Color.fromARGB(255, 56, 50, 0),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hãy nhập nội dung:)';
                  }
                  return null;
                },
              ),
              // SizedBox(height: 16.0),

              // SizedBox(height: 16.0),
              // Row(
              //   children: [
              //     Icon(
              //       Icons.more_horiz,
              //       color: Color.fromARGB(255, 37, 76, 73),
              //     ),
              //     SizedBox(width: 16.0),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Color.fromARGB(255, 231, 221, 188),
          onPrimary: Colors.black,
          padding: EdgeInsets.all(17.0),
        ),
        onPressed: _saveTask,
        child: Icon(
          Icons.done_sharp,
          size: 26.0,
        ),
      ),
    );
  }
}

class EditTask extends StatefulWidget {
  final Task? task;
  EditTask({Key? key, this.task}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _dueDate;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _dueDate = widget.task!.dueDate;
      _isDone = widget.task!.isDone;
    } else {
      _title = '';
      _dueDate = DateTime.now();
      _isDone = false;
    }
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2021, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      onConfirm: (date) {
        setState(() {
          _dueDate = date;
        });
      },
      currentTime: _dueDate,
      locale: LocaleType.en,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: ui.Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 13,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/MainBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "Edit Note",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ui.Color.fromARGB(255, 233, 233, 233),
                            shadows: [
                              Shadow(
                                color: ui.Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.9),
                                offset: Offset(0, 0),
                                blurRadius: 25,
                              ),
                            ],
                            fontFamily: 'Quicksand'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 96.0),
                  Text(
                    DateFormat('dd MMM yyyy').format(_dueDate),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: Icon(Icons.calendar_month_outlined),
                  )
                ],
              ),
              TextFormField(
                initialValue: _title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hãy nhập nội dung:)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
                autofocus: false,
                maxLines: 14,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontSize: 14,
                ),
                cursorColor: Color.fromARGB(255, 56, 50, 0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Color.fromARGB(255, 231, 221, 188),
          onPrimary: Colors.black,
          padding: EdgeInsets.all(17.0),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final updatedTask = Task(
              title: _title,
              dueDate: _dueDate,
              isDone: _isDone,
            );
            Navigator.pop(context, updatedTask);
          }
        },
        child: Icon(
          Icons.done_sharp,
          size: 26.0,
        ),
      ),
    );
  }
}

// giao diện thanh tiêu đề và giao diện của từng task

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: ui.Size.fromHeight(200.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 13,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/MainBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 130),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        "Makine Note 🖋",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ui.Color.fromARGB(255, 233, 233, 233),
                            shadows: [
                              Shadow(
                                color: ui.Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.9),
                                offset: Offset(0, 0),
                                blurRadius: 25,
                              ),
                            ],
                            fontFamily: 'Quicksand'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, box, _) {
          List<Task> tasks = box.values.toList();
          tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final now = DateTime.now();
              final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
              final endOfWeek = startOfWeek.add(Duration(days: 6));
              final isThisWeek = task.dueDate.isAfter(startOfWeek) &&
                  task.dueDate.isBefore(endOfWeek);
              final subtitle = isThisWeek ? 'In this week' : 'Up coming';
              return Dismissible(
                key: Key(task.title),
                direction: task.isDone
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                onDismissed: (direction) {
                  box.deleteAt(index);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 9,
                    right: 9,
                    top: 3,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                          color: ui.Color.fromARGB(255, 255, 255, 255)),
                    ),
                    elevation: 10.0,
                    child: ListTile(
                      onTap: () async {
                        final updatedTask = await Navigator.push<Task>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTask(task: task)),
                        );
                        if (updatedTask != null) {
                          box.putAt(index, updatedTask);
                        }
                      },
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          task.isDone = value!;
                          box.putAt(index, task);
                        },
                        activeColor: Color.fromARGB(255, 62, 58, 58),
                        shape: CircleBorder(),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            color: Colors.black,
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due on ${DateFormat('MMM d, yyyy').format(task.dueDate)}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11.0,
                              color: ui.Color.fromARGB(115, 11, 10, 6),
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11.0,
                              color: isThisWeek
                                  ? Colors.green
                                  : ui.Color.fromARGB(255, 217, 157, 83),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: ui.Color.fromARGB(255, 231, 221, 188),
          onPrimary: Color.fromARGB(255, 57, 56, 56),
          padding: EdgeInsets.all(20.0),
        ),
        onPressed: () async {
          final task = await Navigator.push<Task>(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TaskPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.fastOutSlowIn;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
        },
        child: Icon(
          Icons.add,
          size: 20.0,
        ),
      ),
    );
  }
}

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => TaskPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
