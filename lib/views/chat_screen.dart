import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqttmsg/core/locale/storage.dart';
import 'package:mqttmsg/core/mqtt/mqtt_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamSubscription subscription;
  List<Map<String, dynamic>> messages = [];
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    MqttProvider.i.publishMessage("TestMesajı");
    subscription = LocalStorage.mqttStream.listen((event) {
      print("Event: $event");
      setState(() {
        messages.add({
          "type": 0,
          "name": "He/She",
          "message": event,
        });
        print("messages: $messages");
      });
      scrollDown();
    });
  }

  @override
  void dispose() {
    super.dispose();
    MqttProvider.i.disconnectClient();
    subscription.cancel();
  }

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Eren"),
          actions: [
            IconButton(
                onPressed: () {
                  MqttProvider.i.disconnectClient();
                  subscription.cancel();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.isNotEmpty ? messages.length : 0,
                itemBuilder: (context, i) {
                  return messages.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.only(
                            left: messages[i]['type'] == 0 ? 0 : 24,
                            right: messages[i]['type'] == 0 ? 24 : 0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          alignment: messages[i]['type'] == 0 ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: messages[i]['type'] == 0 ? Colors.blue : Colors.grey,
                              borderRadius: messages[i]['type'] == 0
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(23.0),
                                      topRight: Radius.circular(23.0),
                                      bottomLeft: Radius.circular(23),
                                    )
                                  : const BorderRadius.only(topLeft: Radius.circular(23.0), topRight: Radius.circular(23.0), bottomRight: Radius.circular(23)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  messages[i]['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  messages[i]['message'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: Text("Mesaj Yok"));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: msgController,
                      decoration: const InputDecoration(
                        labelText: "Mesaj Yazınız",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      MqttProvider.i.publishMessage(msgController.text);
                      setState(() {
                        messages.add({
                          "type": 1,
                          "name": "You",
                          "message": msgController.text,
                        });
                        print("messages: $messages");
                        msgController.clear();
                      });
                      scrollDown();
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
