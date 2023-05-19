// import 'package:Makine/src/pages/tasks.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';

// int countUnfinishedTasks(DateTime date) {
//   final taskBox = Hive.box<Task>('tasks');
//   int count = 0;
//   for (int i = 0; i < taskBox.length; i++) {
//     final task = taskBox.getAt(i)!;
//     if (!task.isDone &&
//         task.dueDate.year == date.year &&
//         task.dueDate.month == date.month &&
//         task.dueDate.day == date.day) {
//       count++;
//     }
//   }
//   return count;
// }

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> showNotification(int count) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails('your channel id', 'your channel name',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker');
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0,
//       'Bạn có $count task cần hoàn thành trong ngày hôm nay',
//       null,
//       platformChannelSpecifics,
//       payload: 'item x');
// }
