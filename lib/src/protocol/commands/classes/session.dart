import 'serializable.dart';

class PrismSession extends Serializable {
  String get sessionKey => data["sessionKey"];
  int get version => data["version"];

  PrismSession(super.data);
}
