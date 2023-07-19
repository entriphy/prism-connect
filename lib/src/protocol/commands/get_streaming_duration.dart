import '../command.dart';

class GetStreamingDurationCommand extends Command {
  static const String COMMAND_TYPE = "getStreamingDuration";

  String get broadcastType => command["broadcastType"];
  void set broadcastType(String x) => command["broadcastType"] = x;

  GetStreamingDurationCommand({required String broadcastType})
      : super(COMMAND_TYPE, {"broadcastType": broadcastType});
  GetStreamingDurationCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
