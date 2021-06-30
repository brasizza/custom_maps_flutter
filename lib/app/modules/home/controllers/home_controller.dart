import 'package:custommarker/app/data/model/map_type.dart';
import 'package:custommarker/app/modules/maps/controllers/maps_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _initialPage = 0.obs;
  final _mapController = Get.find<MapsController>();
  int get initialPage => this._initialPage.value;

  @override
  void onInit() {
    super.onInit();
    _mapController.setInitialPosition(-23.5649267, -46.6519566);

    ever(_initialPage, (_page) {
      if (_page == 0) {
        _mapController.getMarkers(type: MyMapTyes.regular);
      } else {
        _mapController.getMarkers(type: MyMapTyes.custom);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  changePage(int page) {
    _initialPage.value = page;
  }
}
