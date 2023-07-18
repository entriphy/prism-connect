import 'package:prism_connect/prism_connect.dart';

const String DEVICE_NAME = "Pixel 7";
const String DEVICE_OS = "android";
const String DEVICE_OS_VERSION = "Android 13";

// Set these
const String HOST = "127.0.0.1";
const int PORT = 54514;

void main() async {
  PrismConnect prism = await PrismConnect.connect(HOST, PORT);
  prism.messageStream.listen((message) async {
    if (message.command is GetDeviceInfoCommand) {
      prism.reply(
        message,
        DeviceInfoCommand(
          id: prism.deviceId,
          name: DEVICE_NAME,
          os: DEVICE_OS,
          osVersion: DEVICE_OS_VERSION,
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      await prism.disconnect();
    }
  });
}
