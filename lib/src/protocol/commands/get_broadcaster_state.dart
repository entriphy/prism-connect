import '../command.dart';

class GetBroadcasterStateCommand extends Command {
  static const String COMMAND_TYPE = "getBroadcasterState";

  String get broadcastType => command["broadcastType"];
  void set broadcastType(String x) => command["broadcastType"] = x;

  GetBroadcasterStateCommand({required String broadcastType})
      : super(COMMAND_TYPE, {"broadcastType": broadcastType});
  GetBroadcasterStateCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
