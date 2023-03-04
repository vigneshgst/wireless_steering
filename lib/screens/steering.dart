import 'package:flutter/material.dart';

class Steering extends StatefulWidget {
  const Steering({Key? key}) : super(key: key);

  @override
  State<Steering> createState() => _SteeringState();
}

class _SteeringState extends State<Steering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset("assets/steering_wheel.png"),
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
        ],
      ),
    );
  }
}
