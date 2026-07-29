import 'package:flutter/material.dart';

class Exeam extends StatefulWidget {
  const Exeam({super.key});

  @override
  State<Exeam> createState() => _ExeamState();
}

class _ExeamState extends State<Exeam> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<int> stopwatchStream() async* {
    int seconds = 0;
    while (true) {
      yield seconds;
      await Future.delayed(const Duration(seconds: 1));
      seconds++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: StreamBuilder<int>(
            stream: stopwatchStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Duration myTime = Duration(seconds: snapshot.data!);

                return Row(
                  spacing: 20,
                  children: [
                  
                    Text(
                      myTime.inSeconds.toString(),
                      style: TextStyle(fontSize: 60),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 100),
                    ),

                    Text(
                      myTime.inMinutes.toString(),
                      style: TextStyle(fontSize: 60),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 100),
                    ),
                    Text(
                      myTime.inHours.toString(),
                      style: TextStyle(fontSize: 60),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
