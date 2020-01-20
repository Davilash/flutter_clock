// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'custom_circle.dart';
import 'drawn_hand.dart';

final radiansPerTick = radians(360 / 60);

final radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: DecoratedBox(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent),
        child: Stack(
          children: [
            new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new CustomPaint(
                painter: new CircleProgress(_now.second.toDouble()),
              ),
            ),
            new Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new CustomPaint(
                painter: new ClockDialPainter(),
              ),
            ),
            new Container(
              color: Colors.transparent,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    DrawnHand(
                      color: Colors.blueGrey,
                      thickness: 6.0,
                      size: 0.9,
                      angleRadians: _now.minute * radiansPerTick,
                      length: 90.0,
                    ),
                    DrawnHand(
                      color: Colors.blueGrey,
                      thickness: 7.0,
                      size: 0.9,
                      angleRadians: _now.hour * radiansPerHour +
                          (_now.minute / 60) * radiansPerHour,
                      length: 70.0,
                    ),
                    new Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            width: 1.0,
                            color: Colors.lightGreen,
                          ),
                          color: Colors.greenAccent),
                    ),
                    FittedBox(
                        child: Text(
                      _temperature,
                      style: new TextStyle(
                          color: Colors.blue[900],
                          fontSize: 15,
                          fontFamily: 'Times New Roman'),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
