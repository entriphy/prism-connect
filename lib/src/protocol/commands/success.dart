import '../command.dart';

class SuccessCommand extends Command {
  static const String COMMAND_TYPE = "success";

  dynamic get result => command["result"];
  void set result(dynamic x) => command["result"] = x;

  SuccessCommand([dynamic result])
      : super(COMMAND_TYPE, {if (result != null) "result": result});
  SuccessCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
