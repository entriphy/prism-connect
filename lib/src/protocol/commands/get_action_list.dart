import '../command.dart';

class GetActionListCommand extends Command {
  static const String COMMAND_TYPE = "getActionList";

  GetActionListCommand() : super(COMMAND_TYPE);
  GetActionListCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
