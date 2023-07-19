import 'commands/connect.dart';
import 'commands/device_info.dart';
import 'commands/disconnect.dart';
import 'commands/failure.dart';
import 'commands/get_action_list.dart';
import 'commands/get_broadcaster_state.dart';
import 'commands/get_current_broadcast.dart';
import 'commands/get_device_info.dart';
import 'commands/get_streaming_duration.dart';
import 'commands/get_supported_broadcast_type_list.dart';
import 'commands/ping.dart';
import 'commands/success.dart';

export 'commands/connect.dart';
export 'commands/device_info.dart';
export 'commands/disconnect.dart';
export 'commands/failure.dart';
export 'commands/get_action_list.dart';
export 'commands/get_broadcaster_state.dart';
export 'commands/get_current_broadcast.dart';
export 'commands/get_device_info.dart';
export 'commands/get_streaming_duration.dart';
export 'commands/get_supported_broadcast_type_list.dart';
export 'commands/ping.dart';
export 'commands/success.dart';

class Command {
  late Map<String, dynamic> _rawData;

  String get commandType => _rawData["commandType"];
  void set commandType(String type) => _rawData["commandType"] = type;
  Map<String, dynamic> get command => _rawData["command"];
  void set command(Map<String, dynamic> d) => _rawData["command"] = d;

  Map<String, dynamic> toJson() => _rawData;

  Command.fromJson(this._rawData);
  Command(String commandType, [Map<String, dynamic>? command]) {
    _rawData = {
      "commandType": commandType,
      "command": command ?? Map<String, dynamic>.from({})
    };
  }

  @override
  String toString() => _rawData.toString();

  static const Map<String, Command Function(Map<String, dynamic> data)>
      commandMap = {
    ConnectCommand.COMMAND_TYPE: ConnectCommand.fromJson,
    DeviceInfoCommand.COMMAND_TYPE: DeviceInfoCommand.fromJson,
    DisconnectCommand.COMMAND_TYPE: DisconnectCommand.fromJson,
    FailureCommand.COMMAND_TYPE: FailureCommand.fromJson,
    GetActionListCommand.COMMAND_TYPE: GetActionListCommand.fromJson,
    GetBroadcasterStateCommand.COMMAND_TYPE:
        GetBroadcasterStateCommand.fromJson,
    GetCurrentBroadcastCommand.COMMAND_TYPE:
        GetCurrentBroadcastCommand.fromJson,
    GetDeviceInfoCommand.COMMAND_TYPE: GetDeviceInfoCommand.fromJson,
    GetStreamingDurationCommand.COMMAND_TYPE:
        GetStreamingDurationCommand.fromJson,
    GetSupportedBroadcastTypeListCommand.COMMAND_TYPE:
        GetSupportedBroadcastTypeListCommand.fromJson,
    PingCommand.COMMAND_TYPE: PingCommand.fromJson,
    SuccessCommand.COMMAND_TYPE: SuccessCommand.fromJson
  };
}
