import 'serializable.dart';

class PrismSource extends Serializable {
  String get id => data["id"];
  bool get isOn => data["isOn"];
  String get name => data["name"];
  int get numberOfChildren => data["numberOfChildren"];
  String get sourceType => data["sourceType"];

  PrismSource(super.data);
}
