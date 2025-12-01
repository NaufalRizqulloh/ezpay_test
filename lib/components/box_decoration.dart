import 'package:flutter/material.dart';
import 'border.dart';

BoxDecoration appBoxDecoration() => BoxDecoration(
  color: Colors.grey[100],
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.5),
      spreadRadius: 3,
      blurRadius: 5,
      offset: Offset(0, 3),
    ),
  ],
  border: appBorder(),
);
