import 'package:flutter/material.dart';

enum TodoTypography { appTitle, todoLine, todoNotDone, todoDone }

extension TodoTypographyExtension on TodoTypography {
  TextStyle? get textstyle {
    switch (this) {
      case TodoTypography.appTitle:
        return const TextStyle(
          fontWeight: FontWeight.bold,
        );
      case TodoTypography.todoLine:
        return const TextStyle(
          fontSize: 24,
        );
      case TodoTypography.todoNotDone:
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        );
      case TodoTypography.todoDone:
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
        );
    }
  }
}
