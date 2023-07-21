import 'serializable.dart';
import 'source.dart';

class PrismAction extends Serializable {
  String get behaviour => data["behaviour"];
  String get id => data["id"];
  PrismSource? get source =>
      data["source"] != null ? PrismSource(data["source"]) : null;
  dynamic get thumbnailId => data["thumbnailId"];
  dynamic get thumbnailUrl => data["thumbnailURL"];
  String get type => data["type"];

  PrismAction(super.data);
}
