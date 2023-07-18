import '../command.dart';

class DeviceInfoCommand extends Command {
  static const String COMMAND_TYPE = "deviceInfo";

  String get id => command["id"];
  void set id(String x) => command["id"] = x;
  String get name => command["name"];
  void set name(String x) => command["name"] = x;
  String get os => command["os"];
  void set os(String x) => command["os"] = x;
  String get osVersion => command["osVersion"];
  void set osVersion(String x) => command["osVersion"] = x;

  DeviceInfoCommand({
    required String id,
    required String name,
    required String os,
    required String osVersion,
  }) : super(COMMAND_TYPE, {
          "id": id,
          "name": name,
          "os": os,
          "osVersion": osVersion,
        });
  DeviceInfoCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
