import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int yAxis = 0;
  int xAxis = 0;
  bool leftTurn = false;
  bool rightTurn = false;
  Timer timer = Timer.periodic(Duration.zero, (timer) {});
  Timer timer1 = Timer.periodic(Duration.zero, (timer) {});
  int steeringAngle = 0;
  bool speedUp = false;
  bool speedDown = false;
  int speed = 0;

  @override
  void dispose() {
    timer.cancel();
    timer1.cancel();
    super.dispose();
  }

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      yAxis = event.y.toInt();
      xAxis = event.x.toInt();

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (yAxis >= 3) {
      if (!timer.isActive) {
        timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
          calculateSteeringAngle();
        });
      }
      rightTurn = true;
      leftTurn = false;
    } else if (yAxis <= -3) {
      if (!timer.isActive) {
        timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
          calculateSteeringAngle();
        });
      }
      rightTurn = false;
      leftTurn = true;
    } else if (yAxis == 0) {
      leftTurn = false;
      rightTurn = false;
      timer.cancel();
    }

    if (xAxis <= -2) {
      if (!timer1.isActive) {
        speedDown = false;
        speedUp = true;
        timer1 = Timer.periodic(const Duration(milliseconds: 20), (timer) {
          calculateSpeed();
        });
      }
    } else if (xAxis >= 8) {
      speedDown = true;
      speedUp = false;
      if (!timer1.isActive) {
        timer1 = Timer.periodic(const Duration(milliseconds: 20), (timer) {
          calculateSpeed();
        });
      }
    } else {
      speedDown = false;
      speedUp = false;
      timer1.cancel();
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Steering Angle",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Card(
                  color: Colors.grey.shade300,
                  shape: const StadiumBorder(),
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: rightTurn,
                        child: const Icon(
                          Icons.turn_right_outlined,
                          color: Colors.green,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          steeringAngle.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                      ),
                      Visibility(
                        visible: leftTurn,
                        child: const Icon(
                          color: Colors.green,
                          Icons.turn_left_outlined,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "Speed",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Card(
                  color: Colors.grey.shade300,
                  shape: const StadiumBorder(),
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: speedUp,
                        child: const Icon(
                          Icons.arrow_upward_sharp,
                          color: Colors.green,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          speed.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                      ),
                      Visibility(
                        visible: speedDown,
                        child: const Icon(
                          color: Colors.red,
                          Icons.arrow_downward_sharp,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void calculateSteeringAngle() {
    if (rightTurn && steeringAngle <= 179) {
      steeringAngle++;
    } else if (leftTurn && steeringAngle >= -179) {
      steeringAngle--;
    }
  }

  void calculateSpeed() {
    if (speedUp && speed < 160) {
      speed++;
    }
    if (speedDown && speed > 0) {
      speed--;
    }
  }
}
