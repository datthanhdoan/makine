import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'dart:ffi';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<String> songs = [
    'Rain-and-Thunderstorm.mp3',
    'Faded.mp3',
    'The-Name-Of-Life-Piano.mp3',
    'Fire-Burning.mp3',
  ];
  int currentSongIndex = 0;
  late AudioPlayer audioPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    currentTime = workTime * 60;
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isPlaying = false;

  void playMusic() async {
    if (audioPlayer.state == PlayerState.PAUSED) {
      await audioPlayer.resume();
    } else {
      await audioCache.play(songs[currentSongIndex]);
    }
  }

  void togglePlay() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      playMusic();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextSong() {
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % songs.length;
    });
    if (isPlaying == true) {
      playMusic();
    }
  }

  void previousSong() {
    setState(() {
      currentSongIndex = (currentSongIndex - 1 + songs.length) % songs.length;
    });
    if (isPlaying == true) {
      playMusic();
    }
  }

  // Hàm chọn thời gian work và break cho Pomodoro
  int workTime = 25;
  int breakTime = 5;
  int currentTime = 0;
  bool isWorking = true;
  Timer? timer;

  void startTimer() {
    if (timer != null && timer!.isActive) {
      // Nếu timer đã được khởi tạo và đang hoạt động, không làm gì cả
      return;
    }

    // Thiết lập lại thời gian dựa trên trạng thái hiện tại (làm việc hay nghỉ)
    if (mounted) {
      setState(() {
        currentTime = isWorking ? workTime * 60 : breakTime * 60;
      });
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime > 0) {
          currentTime--;
        }
        if (currentTime <= 0) {
          timer.cancel();
          isWorking = !isWorking;
          startTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      currentTime = isWorking ? workTime * 60 : breakTime * 60;
    });
  }
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 13,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/TimerAppBar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Phần đồng hồ Pomodoro
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 168, 168, 168),
                    Color.fromARGB(255, 224, 220, 199),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Pomodoro Timer",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color.fromARGB(255, 185, 224, 195),
                        Color.fromARGB(255, 161, 88, 129),
                      ],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: CircularPercentIndicator(
                      progressColor: isWorking ? Colors.red : Colors.green,
                      percent: currentTime /
                          (isWorking ? workTime * 60 : breakTime * 60),
                      animation: false,
                      // animationDuration: 2000,
                      radius: 115,
                      lineWidth: 35,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Center(
                        child: Text(
                          '${currentTime ~/ 60}:${(currentTime % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: startTimer,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: stopTimer,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: resetTimer,
                      ),
                    ],
                  ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Phần trình phát lofi sound
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 168, 168, 168),
                    Color.fromARGB(255, 224, 220, 199),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    songs[currentSongIndex],
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Cập nhật tên bài hát tại đây
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous_rounded),
                        onPressed: previousSong,
                      ),
                      IconButton(
                        icon: Icon(isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_arrow_rounded),
                        onPressed: togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next_rounded),
                        onPressed: nextSong,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
