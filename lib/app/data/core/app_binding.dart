import 'package:custommarker/app/data/repository/maps_respoitory.dart';
import 'package:custommarker/app/modules/maps/controllers/maps_controller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsRepository>(() => MapsRepository());
    Get.lazyPut<MapsController>(() => MapsController(Get.find<MapsRepository>()));
  }
}
