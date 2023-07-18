import '../command.dart';

class DisconnectCommand extends Command {
  static const String COMMAND_TYPE = "disconnect";

  DisconnectCommand() : super(COMMAND_TYPE);
  DisconnectCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
