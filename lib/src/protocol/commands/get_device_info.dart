import '../command.dart';

class GetDeviceInfoCommand extends Command {
  static const String COMMAND_TYPE = "getDeviceInfo";

  GetDeviceInfoCommand() : super(COMMAND_TYPE);
  GetDeviceInfoCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
