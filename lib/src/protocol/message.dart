import 'dart:convert';
import 'dart:typed_data';

import 'command.dart';

class Message {
  late int field4;
  late int field8;
  late int fieldC;
  late int requestId;
  late Command command;

  Message(this.field4, this.field8, this.fieldC, this.requestId, this.command);
  Message.fromBytes(Uint8List data) {
    var blob = ByteData.sublistView(data);
    int length = blob.getUint32(0x0, Endian.little);
    this.field4 = blob.getUint32(0x4, Endian.little);
    this.field8 = blob.getUint32(0x8, Endian.little);
    this.fieldC = blob.getUint32(0xC, Endian.little);
    this.requestId = blob.getUint32(0x10, Endian.little);
    String commandStr = utf8.decode(data.sublist(0x14, length));
    Map<String, dynamic> commandJson = jsonDecode(commandStr);
    if (Command.commandMap.containsKey(commandJson["commandType"])) {
      this.command =
          Command.commandMap[commandJson["commandType"]]!(commandJson);
    } else {
      this.command = Command.fromJson(commandJson);
    }
  }

  Uint8List toBytes() {
    String str = jsonEncode(this.command.json);
    Uint8List reqBytes = utf8.encode(str) as Uint8List;
    int len = reqBytes.lengthInBytes + 0x14;

    Uint8List data = Uint8List(len);
    var blob = ByteData.sublistView(data);
    blob.setUint32(0x0, len, Endian.little);
    blob.setUint32(0x4, field4, Endian.little);
    blob.setUint32(0x8, field8, Endian.little);
    blob.setUint32(0xC, fieldC, Endian.little);
    blob.setUint32(0x10, requestId, Endian.little);
    for (int i = 0; i < reqBytes.length; i++) {
      data[i + 0x14] = reqBytes[i];
    }
    return data;
  }

  @override
  String toString() => command.toString();
}
