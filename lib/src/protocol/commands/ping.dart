import '../command.dart';

class PingCommand extends Command {
  static const String COMMAND_TYPE = "ping";

  PingCommand() : super(COMMAND_TYPE);
  PingCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
