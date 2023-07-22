import 'dart:io';

import 'package:prism_connect/prism_connect.dart';

// Dummy data
const String DEVICE_NAME = "prism-connect Example";
const String DEVICE_OS = "android";
const String DEVICE_OS_VERSION = "Android 13";

// Set these using the QR code from PRISM Live Studio
const String HOST = "127.0.0.1";
const int PORT = 52000;

late PrismConnect prism;

// Exit handler to disconnect cleanly on SIGTERM or SIGINT
void _exitHandler(ProcessSignal signal) async {
  if (!prism.isClosed) {
    print("Disconnecting...");
    await prism.disconnect();
  }
  exit(0);
}

void main() async {
  // Register exit handler
  ProcessSignal.sigterm.watch().listen(_exitHandler);
  ProcessSignal.sigint.watch().listen(_exitHandler);

  // Connect to PRISM Live Studio and print device info
  prism = await PrismConnect.connect(HOST, PORT);
  var deviceInfo = await prism.sendCommand(GetDeviceInfoCommand());
  if (deviceInfo is! DeviceInfoCommand) {
    print("Failed to get server device info: ${deviceInfo}");
    await prism.disconnect();
    exit(1);
  }
  print("Server device info:");
  print("- ID: ${deviceInfo.id}");
  print("- Name: ${deviceInfo.name}");
  print("- OS: ${deviceInfo.os} (${deviceInfo.osVersion})");

  // Get list of actions and subscribe to all actions
  var actionList = await prism.sendCommand(GetActionListCommand());
  if (actionList is SuccessCommand) {
    List<PrismAction> actions = actionList.result
        .map<PrismAction>((action) => PrismAction(action))
        .toList();
    List<String> ids = actions.map((action) => action.id).toList();
    var subscription =
        await prism.sendCommand(SubscribeSourceUpdatedCommand(sourceIds: ids));
    if (subscription is FailureCommand) {
      print("Failed to subscribe to actions: " + subscription.message);
      await prism.disconnect();
      exit(1);
    }
  }

  // Listen and print incoming commands
  print("Listening for commands... (press Ctrl + C to exit)");
  prism.messageStream.listen((message) async {
    print("> ${message.command}");

    // Send deviceInfo when getDeviceInfo is received
    if (message.command is GetDeviceInfoCommand) {
      var deviceInfo = DeviceInfoCommand(
        id: prism.deviceId,
        name: DEVICE_NAME,
        os: DEVICE_OS,
        osVersion: DEVICE_OS_VERSION,
      );
      print("< ${deviceInfo}");
      prism.reply(message, deviceInfo);
    }
  });
}
