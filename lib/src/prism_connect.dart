import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'protocol/command.dart';
import 'protocol/message.dart';

export 'protocol/command.dart';
export 'protocol/message.dart';

class PrismConnect {
  // Private fields
  final Socket _socket;
  final StreamController<Message> _messageStreamController =
      StreamController.broadcast();
  bool _isClosed = false;
  int _requestId = 0;
  late String _deviceId; // Randomized device ID

  // Public fields
  Stream<Message> get messageStream => _messageStreamController.stream;
  bool get isClosed => _isClosed;
  String get deviceId => _deviceId;

  // Private constructor
  PrismConnect._(this._socket) {
    this._socket.listen(_listener, onDone: () => _isClosed = true);

    // Generate device ID
    Random r = Random();
    this._deviceId =
        List<String>.generate(16, (index) => r.nextInt(16).toRadixString(16))
            .join();
  }

  void sendMessage(Message message) {
    _socket.add(message.toBytes());
  }

  Future<Message> call(String type,
      {Map<String, dynamic> data = const {}}) async {
    // Send message
    int id = _requestId++;
    Command command = Command(type, data);
    Message message = Message(1, 1, 1, id, command);
    sendMessage(message);

    // Receive response
    Message response = await messageStream
        .firstWhere((message) => message.requestId == id)
        .timeout(Duration(seconds: 15));
    return response;
  }

  Future<T> sendCommand<T extends Command>(Command command,
      [bool waitForMessage = true]) async {
    Message message = await call(command.commandType, data: command.command);
    return message.command as T;
  }

  void reply(Message message, Command command) async {
    Message m = Message(1, 1, 1, message.requestId, command);
    sendMessage(m);
  }

  void _listener(Uint8List data) {
    Message message = Message.fromBytes(data);
    print(message);
    print(message.requestId);
    _messageStreamController.add(message);
  }

  Future<void> disconnect([bool sendDisconnect = true]) async {
    if (!isClosed && sendDisconnect) {
      await sendCommand(DisconnectCommand());
    }
    await _messageStreamController.close();
    await _socket.close();
  }

  static Future<PrismConnect> connect(String host, int port) async {
    Socket socket = await Socket.connect(host, port);
    PrismConnect prism = PrismConnect._(socket);
    var connect = await prism.sendCommand(
        ConnectCommand(connectType: "remote_control_wifi", version: 1));
    if (connect is FailureCommand) {
      await prism.disconnect(false);
      throw PrismConnectFailureException(connect);
    }
    return prism;
  }
}

class PrismConnectFailureException {
  int code;
  String message;

  PrismConnectFailureException(FailureCommand command)
      : code = command.code,
        message = command.message;

  @override
  String toString() => "$code: $message";
}
