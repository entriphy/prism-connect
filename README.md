# prism_connect
Reverse-engineered remote protocol and commands for PRISM Live Studio v4.0.0+.

This repository provides a Dart library to use the remote protocol, which is compatible with Flutter (uses `dart:io`, no web support). If you wish to implement the protocol for yourself, [protocol documentation](https://github.com/entriphy/prism-connect/blob/main/protocol.md) is also provided.

## Quick start
**A working program using these examples can be found in `example/example.dart`.**

#### Add package to `pubspec.yaml`
```yml
dependencies:
    prism_connect: ^1.0.0
```

#### Import the package
```dart
import 'package:prism_connect/prism_connect.dart';
```

#### Connect to PRISM Live Studio
(use the port from the QR code within the app):
```dart
PrismConnect prism = await PrismConnect.connect("127.0.0.1", 50000);
```

#### Send a command
(see `src/protocol/commands` directory for all available commands):
```dart
Command deviceInfo = await prism.sendCommand(GetDeviceInfoCommand());
```
In case the command does not have a class, you can also use `call` to send a custom command:
```dart
Command deviceInfo = await prism.call("getDeviceInfo");
```
Note: `Command` is a base class; the return type could actually be `SuccessCommand`/`FailureCommand`, or in this example, `DeviceInfoCommand`

#### Listen and reply to commands
```dart
prism.messageStream.listen((message) async {
    print(message.command);

    // Server sends this command to client every few seconds
    if (message.command is GetDeviceInfoCommand) {
      var deviceInfo = DeviceInfoCommand(
        id: prism.deviceId,
        name: DEVICE_NAME,
        os: DEVICE_OS,
        osVersion: DEVICE_OS_VERSION,
      );
      prism.reply(message, deviceInfo);
    }
})
```

#### Disconnect
```dart
await prism.disconnect();
```