import 'package:custommarker/app/modules/maps/controllers/maps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends GetView<MapsController> {
  @override
  Widget build(BuildContext context) {
    return controller.obx((state) => Obx(() => GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: controller.initialPositionMap,
            zoom: 12,
          ),
          zoomControlsEnabled: true,
          markers: controller.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          buildingsEnabled: false,
          circles: controller.circle,
        )));
  }
}
