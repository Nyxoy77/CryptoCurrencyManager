import 'package:get/get.dart';
import 'package:get_ex_currency/controllers/assets_controller.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:get_ex_currency/services/dio_service.dart';

Future<void> registerServices() async {
  Get.put(
    DioService(),
  );
}

Future<void> registerAssest() async {
  Get.put(
    AssetsController(),
  );
}
