import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/page/home_page.dart';
import 'package:simple_todo/page/loading_page.dart';
import 'package:simple_todo/repository/hive_service.dart';
import 'package:simple_todo/repository/todo_repository.dart';

final autoInjector = AutoInjector();

// ignore_for_file: avoid_print
void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
        '${record.time}:  ${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  autoInjector.addSingleton(HiveService.new);
  autoInjector.addLazySingleton(TodoRepository.new);

  autoInjector.commit();

  runApp(
    MaterialApp(
      title: "A simple todo list",
      initialRoute: "/loading",
      routes: {
        "/loading": (context) => const LoadingPage(),
        "/main": (context) => const HomePage(),
      },
    ),
  );
}
