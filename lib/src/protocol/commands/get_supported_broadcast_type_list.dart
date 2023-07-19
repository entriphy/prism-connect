import '../command.dart';

class GetSupportedBroadcastTypeListCommand extends Command {
  static const String COMMAND_TYPE = "getSupportedBroadcastTypeList";

  GetSupportedBroadcastTypeListCommand() : super(COMMAND_TYPE);
  GetSupportedBroadcastTypeListCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
