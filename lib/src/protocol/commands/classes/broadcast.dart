import 'serializable.dart';
import 'broadcast_target.dart';

class PrismBroadcast extends Serializable {
  String get id => data["id"];
  String get startedDate => data["startedDate"];
  List<PrismBroadcastTarget> get targets => data["targets"]
      .map<PrismBroadcastTarget>((target) => PrismBroadcastTarget(target))
      .toList();
  String get type => data["type"];

  PrismBroadcast(super.data);
}
