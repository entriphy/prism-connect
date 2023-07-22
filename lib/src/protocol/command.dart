import 'commands/changed_broadcaster_state.dart';
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
import 'commands/send_action.dart';
import 'commands/subscribe_source_updated.dart';
import 'commands/success.dart';
import 'commands/unsubscribe_source_updated.dart';
import 'commands/updated_source.dart';

export 'commands/changed_broadcaster_state.dart';
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
export 'commands/send_action.dart';
export 'commands/subscribe_source_updated.dart';
export 'commands/success.dart';
export 'commands/unsubscribe_source_updated.dart';
export 'commands/updated_source.dart';

export 'commands/classes/action.dart';
export 'commands/classes/broadcast_target.dart';
export 'commands/classes/broadcast.dart';
export 'commands/classes/session.dart';
export 'commands/classes/source.dart';

class Command {
  late Map<String, dynamic> _rawData;

  String get commandType => _rawData["commandType"];
  void set commandType(String type) => _rawData["commandType"] = type;
  Map<String, dynamic> get command => _rawData["command"];
  void set command(Map<String, dynamic> d) => _rawData["command"] = d;

  Map<String, dynamic> get json => _rawData;

  Command.fromJson(this._rawData);
  Command(String commandType, [Map<String, dynamic>? command]) {
    _rawData = {
      "commandType": commandType,
      "command": command ?? Map<String, dynamic>.from({})
    };
  }

  @override
  String toString() => "${commandType}(${command.isNotEmpty ? command : ''})";

  static const Map<String, Command Function(Map<String, dynamic> data)>
      commandMap = {
    ChangedBroadcasterStateCommand.COMMAND_TYPE:
        ChangedBroadcasterStateCommand.fromJson,
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
    SendActionCommand.COMMAND_TYPE: SendActionCommand.fromJson,
    SubscribeSourceUpdatedCommand.COMMAND_TYPE:
        SubscribeSourceUpdatedCommand.fromJson,
    SuccessCommand.COMMAND_TYPE: SuccessCommand.fromJson,
    UnsubscribeSourceUpdatedCommand.COMMAND_TYPE:
        UnsubscribeSourceUpdatedCommand.fromJson,
    UpdatedSourceCommand.COMMAND_TYPE: UpdatedSourceCommand.fromJson,
  };
}
