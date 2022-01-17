import 'package:flutter/material.dart';
import 'package:mqttmsg/core/mqtt/mqtt_provider.dart';
import 'package:mqttmsg/views/login_screen.dart';

Future<void> main() async {
  await MqttProvider.i.initMqtt();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
