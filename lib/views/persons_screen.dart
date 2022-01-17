import 'package:flutter/material.dart';
import 'package:mqttmsg/core/locale/storage.dart';
import 'package:mqttmsg/core/mqtt/mqtt_provider.dart';
import 'package:mqttmsg/views/chat_screen.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({Key? key}) : super(key: key);

  @override
  _PersonsScreenState createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  TextEditingController usrnmeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MqttProvider.i.subscribeToTopic(LocalStorage.myUsername!);
  }

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
                  labelText: "Karşı Kullanıcı Adı",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalStorage.setSendUsername("topic/${usrnmeController.text}");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                },
                child: const Text("Sohbete Başla"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
