import '../command.dart';

class GetCurrentBroadcastCommand extends Command {
  static const String COMMAND_TYPE = "getCurrentBroadcast";

  String get broadcastType => command["broadcastType"];
  void set broadcastType(String x) => command["broadcastType"] = x;

  GetCurrentBroadcastCommand({required String broadcastType})
      : super(COMMAND_TYPE, {"broadcastType": broadcastType});
  GetCurrentBroadcastCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
