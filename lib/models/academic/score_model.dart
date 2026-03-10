import 'package:flutter/material.dart';

class ScoreModel {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final double? averageScore;
  final String className;

  ScoreModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    this.averageScore,
    required this.className,
  });
}
