import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int yAxis = 0;

  bool leftTurn = false;
  bool rightTurn = false;
  Timer timer = Timer.periodic(Duration.zero, (timer) {});
  Timer timer1 = Timer.periodic(Duration.zero, (timer) {});
  int steeringAngle = 0;
  bool switchOn = false;
  int speed = 0;

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      yAxis = event.y.toInt();

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (yAxis >= 3) {
      if (!timer.isActive) {
        timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          calculateSteeringAngle();
        });
      }
      rightTurn = true;
      leftTurn = false;
    } else if (yAxis <= -3) {
      if (!timer.isActive) {
        timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
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

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Speed: $speed Kmph ",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      steeringAngle = 0;
                    },
                    child: const Text("Active Return",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: StepProgressIndicator(
                      totalSteps: 50,
                      currentStep: (speed ~/ 2).toInt(),
                      size: 50,
                      selectedColor: Colors.white,
                      unselectedColor: Colors.grey,
                      roundedEdges: const Radius.circular(10),
                    ),
                  ),
                  Column(
                    children: [
                      const Text("Virtual Assist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      Switch(
                          value: switchOn,
                          onChanged: (status) {
                            switchOn = status;
                          }),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        timer1.cancel();
                      },
                      onTapCancel: () {
                        timer1.cancel();
                      },
                      onTapDown: (TapDownDetails details) {
                        timer1 = Timer.periodic(
                            const Duration(milliseconds: 100), (timer) {
                          if (speed > 0) {
                            speed--;
                          }
                        });
                      },
                      child: const Card(
                        shape: StadiumBorder(),
                        color: Colors.red,
                        elevation: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Break",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: const StadiumBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Visibility(
                                visible: rightTurn,
                                child: const Icon(
                                  Icons.turn_right_outlined,
                                  size: 75,
                                  color: Colors.orange,
                                )),
                          ),
                          Transform.rotate(
                            angle: steeringAngle / 500.toDouble(),
                            child: Image.asset("assets/steering_wheel.png"),
                          ),
                          Expanded(
                            child: Visibility(
                                visible: leftTurn,
                                child: const Icon(
                                  Icons.turn_left_outlined,
                                  size: 75,
                                  color: Colors.orange,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        timer1.cancel();
                      },
                      onTapCancel: () {
                        timer1.cancel();
                      },
                      onTapDown: (TapDownDetails details) {
                        timer1 = Timer.periodic(
                            const Duration(milliseconds: 100), (timer) {
                          if (speed < 100) {
                            speed++;
                          }
                        });
                      },
                      child: const Card(
                        shape: StadiumBorder(),
                        color: Colors.green,
                        elevation: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Gas",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Steering Angle: $steeringAngle ",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void calculateSteeringAngle() {
    if (rightTurn && steeringAngle <= 1350) {
      steeringAngle += 50;
    } else if (leftTurn && steeringAngle >= -1350) {
      steeringAngle -= 50;
    }
  }
}
