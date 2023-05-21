import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hive/hive.dart';
import 'package:Makine/src/pages/tasks.dart';
import 'package:confetti/confetti.dart';

class TaskChart extends StatelessWidget {
  final List<Task> tasks;
  final ConfettiController _confettiController = ConfettiController();

  TaskChart({required this.tasks});

  @override
  Widget build(BuildContext context) {
    int allTasks = 0;
    int completedTasks = 0;
    int totalsCp = 0;
    final box = Hive.box<Task>('tasks');
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 7));
    final totals = box.length;
    for (int i = 0; i < box.length; i++) {
      final task = box.getAt(i)!;
      if (task.isDone) {
        totalsCp++;
      }
      if (task.dueDate.isAfter(startOfWeek) &&
          task.dueDate.isBefore(endOfWeek)) {
        allTasks++;
        if (task.isDone) {
          completedTasks++;
        }
      }
    }

    // Phần trăm số task đã hoàn thành / chưa hoàn thành TRONG TUẦN

    final percentTasks;
    if (allTasks == 0) {
      percentTasks = 0;
    } else {
      percentTasks = (completedTasks / allTasks) * 100;
    }

    // Phần trăm số task đã hoàn thành / chưa hoàn thành
    final percentTotals;
    if (totals == 0) {
      percentTotals = 0;
    } else {
      percentTotals = (totalsCp / totals) * 100;
    }

    // Nếu hoàn thiện toàn bộ task thì sẽ có hiệu ứng chúc mừng
    if (percentTotals == 100) {
      _confettiController.play();
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 13,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/ChartAppBar.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Padding(
              //   padding: EdgeInsets.fromLTRB(15, 160, 0, 20),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Column(
              //       children: [
              //         Text(
              //           "Makine Note 🖋",
              //           style: TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //             color: Color.fromARGB(255, 1, 1, 0),
              //             shadows: [
              //               Shadow(
              //                 color: Colors.black.withOpacity(0.5),
              //                 offset: Offset(0, 0),
              //                 blurRadius: 10,
              //               ),
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: pi / 2,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
                numberOfParticles: 20,
                gravity: 0.1,
              ),
              Text(
                "In this week:",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Text(
                      "Incomplete: ${allTasks - completedTasks} ☕",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Done : $completedTasks 🔥",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color.fromARGB(255, 182, 200, 136),
                    Color.fromARGB(255, 104, 138, 19),
                  ],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 2000,
                  radius: 115,
                  lineWidth: 35,
                  percent: percentTasks / 100,
                  progressColor: Color.fromARGB(255, 84, 188, 87),
                  backgroundColor: Color.fromARGB(255, 223, 224, 191),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    ' ${percentTasks.toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 55, color: Color.fromARGB(255, 59, 55, 23)),
                  ),
                ),
              ),
              Text(
                "Totals 🏇 !!",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF78962C),
                    Color(0xFF526E0E),
                  ],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: LinearPercentIndicator(
                  animation: true,
                  animationDuration: 2000,
                  center: Text(
                    ' ${percentTotals.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  lineHeight: 20,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  barRadius: Radius.circular(30),
                  percent: percentTotals / 100,
                  progressColor: Color.fromARGB(255, 84, 188, 87),
                  backgroundColor: Color.fromARGB(255, 223, 224, 191),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
