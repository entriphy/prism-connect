import '../command.dart';

class SuccessCommand<T extends dynamic> extends Command {
  static const String COMMAND_TYPE = "success";

  T? get result => command["result"];
  void set result(T? x) => command["result"] = x;

  SuccessCommand([T? result])
      : super(COMMAND_TYPE, {if (result != null) "result": result});
  SuccessCommand.fromJson(Map<String, dynamic> data) : super.fromJson(data);
}
