// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:hive/hive.dart';
// import 'package:Makine/src/pages/tasks.dart';

// class TaskChart extends StatelessWidget {
//   final List<Task> tasks;

//   TaskChart({required this.tasks});

//   @override
//   Widget build(BuildContext context) {
//     int incompleteTasks = 0;
//     int completedTasks = 0;
//     final box = Hive.box<Task>('tasks');
//     final now = DateTime.now();
//     final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     final endOfWeek = startOfWeek.add(Duration(days: 7));
//     for (int i = 0; i < box.length; i++) {
//       final task = box.getAt(i)!;
//       if (task.dueDate.isAfter(startOfWeek) &&
//           task.dueDate.isBefore(endOfWeek)) {
//         incompleteTasks++;
//         if (task.isDone) {
//           completedTasks++;
//         }
//       }
//     }

//     List<Series<TaskData, String>> seriesList = [
//       Series<TaskData, String>(
//         id: 'Tasks',
//         domainFn: (TaskData taskData, _) => taskData.status,
//         measureFn: (TaskData taskData, _) => taskData.count,
//         data: [
//           TaskData('Completed', completedTasks),
//           TaskData('Incomplete', incompleteTasks),
//         ],
//         colorFn: (TaskData taskData, _) => taskData.status == 'Completed'
//             ? MaterialPalette.green.shadeDefault
//             : MaterialPalette.red.shadeDefault,
//       ),
//     ];

//     return Container(
//       padding: EdgeInsets.all(30),
//       child: BarChart(
//         seriesList,
//         animate: true,
//         primaryMeasureAxis: NumericAxisSpec(
//           tickProviderSpec: BasicNumericTickProviderSpec(
//             desiredTickCount: 3,
//           ),
//           renderSpec: GridlineRendererSpec(
//             labelStyle: TextStyleSpec(
//               fontSize: 14,
//               color: MaterialPalette.gray.shade400,
//             ),
//             lineStyle: LineStyleSpec(
//               color: MaterialPalette.gray.shade200,
//             ),
//           ),
//         ),
//         domainAxis: OrdinalAxisSpec(
//           renderSpec: SmallTickRendererSpec(
//             labelStyle: TextStyleSpec(
//               fontSize: 14,
//               color: MaterialPalette.gray.shade400,
//             ),
//             lineStyle: LineStyleSpec(
//               color: MaterialPalette.gray.shade200,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TaskData {
//   final String status;
//   final int count;

//   TaskData(this.status, this.count);
// }
