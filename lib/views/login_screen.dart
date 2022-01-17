import 'package:flutter/material.dart';
import 'package:mqttmsg/core/locale/storage.dart';
import 'package:mqttmsg/views/persons_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usrnmeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MQTT Mesajlaşmaya Hoşgeldin"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usrnmeController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adınız",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalStorage.setMyUsername("topic/${usrnmeController.text}");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PersonsScreen()));
                },
                child: const Text("Giriş"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
