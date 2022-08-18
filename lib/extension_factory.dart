import 'package:flutter/material.dart';

extension ExtensionFactory on Widget {
  Widget bgColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }
}
