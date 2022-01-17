import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttmsg/core/constants/constants.dart';
import 'package:mqttmsg/core/locale/storage.dart';

enum MqttCurrentConnectionState { idle, connecting, connected, disconnected, errorWhenConnecting }

enum MqttSubscriptionState { idle, subscribed }

class MqttProvider {
  MqttProvider._();
  static final MqttProvider _instance = MqttProvider._();
  static MqttProvider get i => _instance;

  MqttServerClient client = MqttServerClient.withPort(MqttConstants.server, MqttConstants.clientIdentifier, MqttConstants.port);

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  Future<void> initMqtt() async {
    _setupMqttClient();
    await _connectClient();
  }

  void _setupMqttClient() {
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<void> _connectClient() async {
    try {
      print('İstemciye Bağlanılıyor....');
      connectionState = MqttCurrentConnectionState.connecting;
      await client.connect(MqttConstants.username, MqttConstants.password);
    } on Exception catch (e) {
      print('İstemci istisna - $e');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.connected;
      print('İstemciye Bağlandı');
    } else {
      print('ERROR İstemciye Bağlantı Hatası - Bağlantı kesintisi, Durum: ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }
  }

  Future<void> disconnectClient() async {
    client.disconnect();
  }

  void subscribeToTopic(String topicName) {
    print('Abone olunan başlık: $topicName');
    client.subscribe(topicName, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      LocalStorage.streamController.add(pt);
      print('ÇIKTI::Değerler:: Başlık: <${c[0].topic}>, cevap: <-- $pt -->');
      print('');
    });
  }

  void publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic ${LocalStorage.sendUsername}');
    client.publishMessage(LocalStorage.sendUsername!, MqttQos.exactlyOnce, builder.payload!);
  }

  //EVENTS
  void _onSubscribed(String topic) {
    print('Abone olundu: $topic!');
    subscriptionState = MqttSubscriptionState.subscribed;
  }

  void _onDisconnected() {
    print('Bağlantı Kesildi!');
    connectionState = MqttCurrentConnectionState.disconnected;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.connected;
    print('Bağlantı Başarılı!');
  }
}
