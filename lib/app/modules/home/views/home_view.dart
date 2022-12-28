import 'package:custommarker/app/modules/maps/views/maps_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google maps Markers'),
        centerTitle: true,
      ),
      body: Center(child: MapsView()),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: (controller.initialPage == 0) ? MaterialStateProperty.all<Color>(Colors.green.shade900) : null,
                  ),
                  onPressed: () {
                    controller.changePage(0);
                  },
                  icon: Icon(Icons.map_sharp),
                  label: Text("Regular Markers"),
                )),
            Obx(() => ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: (controller.initialPage == 1) ? MaterialStateProperty.all<Color>(Colors.green.shade900) : null,
                  ),
                  onPressed: () {
                    controller.changePage(1);
                  },
                  icon: Icon(Icons.map_sharp),
                  label: Text("Custom Markers"),
                )),
          ],
        ),
      ),
    );
  }
}
