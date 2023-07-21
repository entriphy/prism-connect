import 'serializable.dart';

class PrismBroadcastTarget extends Serializable {
  String get endURL => data["endURL"];
  String get platform => data["platform"];

  PrismBroadcastTarget(super.data);
}
