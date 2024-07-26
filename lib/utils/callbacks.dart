import 'package:company/utils/shared.dart';
import 'package:hive/hive.dart';

Future<void> init() async {
  Hive.init(null);
  userData = await Hive.openBox("userData");
}
