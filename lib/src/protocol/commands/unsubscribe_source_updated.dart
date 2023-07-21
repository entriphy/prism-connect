import '../command.dart';

class UnsubscribeSourceUpdatedCommand extends Command {
  static const String COMMAND_TYPE = "unsubscribeSourceUpdated";

  List<String> get sourceIds => command["sourceIds"];
  void set sourceIds(List<String> x) => command["sourceIds"] = x;

  UnsubscribeSourceUpdatedCommand({required List<String> sourceIds})
      : super(COMMAND_TYPE, {"sourceIds": sourceIds});
  UnsubscribeSourceUpdatedCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
