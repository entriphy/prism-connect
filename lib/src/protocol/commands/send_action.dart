import '../command.dart';

class SendActionCommand extends Command {
  static const String COMMAND_TYPE = "sendAction";

  String get actionId => command["actionId"];
  void set actionId(String x) => command["actionId"] = x;

  SendActionCommand({required String actionId})
      : super(COMMAND_TYPE, {"actionId": actionId});
  SendActionCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
