import '../command.dart';

class SubscribeSourceUpdatedCommand extends Command {
  static const String COMMAND_TYPE = "subscribeSourceUpdated";

  List<String> get sourceIds => command["sourceIds"];
  void set sourceIds(List<String> x) => command["sourceIds"] = x;

  SubscribeSourceUpdatedCommand({required List<String> sourceIds})
      : super(COMMAND_TYPE, {"sourceIds": sourceIds});
  SubscribeSourceUpdatedCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
