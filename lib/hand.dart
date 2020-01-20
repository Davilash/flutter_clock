// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

abstract class Hand extends StatelessWidget {
  const Hand({
    @required this.color,
    @required this.size,
    @required this.angleRadians,
    @required this.length,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(length != null);

  final Color color;
  final double size;

  final double angleRadians;

  final double length;
}
