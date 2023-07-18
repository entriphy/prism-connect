import '../command.dart';

class ConnectCommand extends Command {
  static const String COMMAND_TYPE = "connect";

  String get connectType => command["connectType"];
  void set connectType(String x) => command["connectType"] = x;
  int get version => command["version"];
  void set version(int x) => command["version"] = x;

  ConnectCommand({required String connectType, required int version})
      : super(COMMAND_TYPE, {"connectType": connectType, "version": version});
  ConnectCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
