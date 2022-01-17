import 'dart:async';

class LocalStorage {
  LocalStorage._();
  static final LocalStorage _instance = LocalStorage._();
  static LocalStorage get i => _instance;

  static String? myUsername;
  static String? sendUsername;

  static String? get getMyUsername => myUsername;
  static String? get getSendUsername => sendUsername;

  static void setMyUsername(String username) {
    myUsername = username;
  }

  static void setSendUsername(String username) {
    sendUsername = username;
  }
  static StreamController<String> streamController = StreamController<String>.broadcast();
  static Stream<String> get mqttStream => streamController.stream;
}
