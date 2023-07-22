import '../command.dart';

class ChangedBroadcasterStateCommand extends Command {
  static const String COMMAND_TYPE = "changedBroadcasterState";

  String get broadcastType => command["broadcastType"];
  void set broadcastType(String x) => command["broadcastType"] = x;
  String get broadcasterState => command["broadcasterState"];
  void set broadcasterState(String x) => command["broadcasterState"] = x;

  ChangedBroadcasterStateCommand(
      {required String broadcastType, required String broadcasterState})
      : super(COMMAND_TYPE, {
          "broadcastType": broadcastType,
          "broadcasterState": broadcasterState
        });
  ChangedBroadcasterStateCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
