import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//test
//test2
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String milisecondText = '';
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stopebelTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(
        children: [
          Align(
              alignment: const Alignment(0, -0.8),
              child: Text(
                'Test your\nreaction speed',
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                textAlign: TextAlign.center,
              )),
          Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Color(0xFF6D6D6D),
                child: SizedBox(
                  width: 300,
                  height: 160,
                  child: Center(
                    child: Text(
                      milisecondText,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
          Align(
              alignment: const Alignment(0, 0.8),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      milisecondText ='';
                      _startWaitingTimer();

                      break;
                    case GameState.waiting:
                      gameState = GameState.canBeStopped;
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stopebelTimer?.cancel();
                      break;
                  }
                }),
                child: ColoredBox(
                  color: _getButtonColor(),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text(
                        _getButtonText(),
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return 'START';

      case GameState.waiting:
        return 'WAIT';

      case GameState.canBeStopped:
        return 'STOP';
    }
  }


  Color _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);

      case GameState.waiting:
        return Color(0xFFE0982D);

      case GameState.canBeStopped:
        return Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomMileseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMileseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });

      _startStopebel();
    });
  }

  void _startStopebel() {
    stopebelTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        milisecondText = '${timer.tick * 16} ms';
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stopebelTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
