import 'package:location/location.dart';

abstract class ISendLocation {
  Future<bool> insertNode(LocationData current);

  Future<bool> updateNode(value);
}
