import 'package:Makine/src/pages/chart.dart';
import 'package:flutter/material.dart';
import 'package:Makine/src/pages/tasks.dart';
import 'package:Makine/src/pages/timer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NoteApp extends StatefulWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _page = [
    HomePage(),
    TaskChart(tasks: []),
    TimerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        height: 65,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 43, 26, 15),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                offset: Offset(-6, -6),
                blurRadius: 25,
                color: Color.fromARGB(209, 240, 240, 240),
              ),
              BoxShadow(
                offset: Offset(6, 6),
                blurRadius: 25,
                color: Color.fromARGB(255, 7, 20, 39),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(5.5),
          child: GNav(
            backgroundColor: Color.fromARGB(255, 43, 26, 15),
            color: Color.fromARGB(255, 219, 218, 218),
            activeColor: Colors.black,
            tabBackgroundColor: Color.fromARGB(255, 196, 189, 183),
            gap: 8,
            padding: EdgeInsets.all(13.5),
            tabs: const [
              GButton(
                icon: Icons.add_task_rounded,
                text: 'Task',
              ),
              GButton(
                icon: Icons.bubble_chart_outlined,
                text: 'Chart',
              ),
              GButton(
                icon: Icons.alarm_sharp,
                text: 'Timer',
              ),
            ],
            onTabChange: (index) {
              _navigateBottomBar(index);
            },
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
