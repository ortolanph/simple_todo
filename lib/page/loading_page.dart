import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logging/logging.dart';

import '../main.dart';
import '../repository/hive_service.dart';

// ignore_for_file: use_build_context_synchronously
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final HiveService _hiveService = autoInjector.get<HiveService>();
  Logger logger = Logger("loading_page");

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitPianoWave(
          color: Colors.white,
          itemCount: 7,
          type: SpinKitPianoWaveType.center,
        )));
  }

  void load() async {
    logger.info("Initializing Hive");
    await _hiveService.init();
    logger.info("Hive Initialized");

    logger.info("Redirecting to the main screen");
    Navigator.pushReplacementNamed(context, "/main");
  }
}
