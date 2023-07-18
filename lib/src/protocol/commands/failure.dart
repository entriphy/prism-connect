import '../command.dart';

class FailureCommand extends Command {
  static const String COMMAND_TYPE = "failure";

  int get code => command["code"];
  void set code(int x) => command["code"] = x;
  String get domain => command["domain"];
  void set domain(String x) => command["domain"] = x;
  String get message => command["message"];
  void set message(String x) => command["message"] = x;

  FailureCommand({
    required String code,
    required String domain,
    required String message,
  }) : super(COMMAND_TYPE, {
          "code": code,
          "domain": domain,
          "message": message,
        });
  FailureCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
