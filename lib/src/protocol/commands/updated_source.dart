import '../command.dart';

class UpdatedSourceCommand extends Command {
  static const String COMMAND_TYPE = "updatedSource";

  PrismSource get source => PrismSource(command["source"]);
  void set source(PrismSource x) => command["source"] = x.data;

  UpdatedSourceCommand({required PrismSource source})
      : super(COMMAND_TYPE, {"source": source.data});
  UpdatedSourceCommand.fromJson(Map<String, dynamic> data)
      : super.fromJson(data);
}
