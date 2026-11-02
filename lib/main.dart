import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BugPage(),
    );
  }
}

class BugPage extends StatefulWidget {
  const BugPage({super.key});

  @override
  State<BugPage> createState() => _BugPageState();
}

class _BugPageState extends State<BugPage> {
  late final Future iosBackgroundTask;

  @override
  void initState() {
    super.initState();
    iosBackgroundTask = FlutterBackgroundService().configure(
      iosConfiguration: IosConfiguration(
        onForeground: null, // we only need to run when in background
        onBackground: backgroundTaskIOS,
        autoStart: true,
      ),
      // not relevant
      androidConfiguration: AndroidConfiguration(
        onStart: (_) {},
        isForegroundMode: false,
        autoStart: false,
        autoStartOnBoot: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Video Plugin in background threads / isolates crashes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            FutureBuilder(
              future: iosBackgroundTask,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Text('Scheduling background task');
                }
                return Text(
                  'iOS background task scheduled.\nMove app to background and wait for'
                  'background job to run to observe the crash',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
FutureOr<bool> backgroundTaskIOS(ServiceInstance _) async {
  // nothing necessary here.
  // Just needs to exist so that the background task can run and crash

  return true;
}
