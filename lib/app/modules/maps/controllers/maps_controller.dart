import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:custommarker/app/data/model/location_model.dart';
import 'package:custommarker/app/data/model/map_type.dart';
import 'package:custommarker/app/modules/maps/views/components/location_destription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MapsController extends GetxController with StateMixin<List<LocationModel>> {
  final repository;
  Rx<Set<Marker>> _markers = Rx<Set<Marker>>({});
  Set<Marker> get markers => this._markers.value.toSet();

  final _googleMapController = Completer().obs;
  Completer get googleMaps => this._googleMapController.value;
  set googleMaps(Completer newValue) => this._googleMapController.value = newValue;

  final _initialPositionMap = LatLng(0, 0).obs;
  LatLng get initialPositionMap => this._initialPositionMap.value;

  MapsController(this.repository);
  @override
  void onInit() {
    super.onInit();
    getMarkers();
  }

  Future<void> getMarkers({type = MyMapTyes.regular}) async {
    change(null, status: RxStatus.loading());
    this.repository.getData().then((List<LocationModel> locations) {
      _generateMarkers(type, locations);
      change(locations, status: RxStatus.success());
    }, onError: (err) {
      print(err);
      change(
        null,
        status: RxStatus.error('Error get data'),
      );
    });
  }

  Future<void> _generateMarkers(MyMapTyes type, List<LocationModel> locations) async {
    _markers.value.clear();
    _markers.refresh();

    await Future.forEach(locations, (LocationModel location) async {
      Marker _mark = await _generateMarker(type, location);
      _markers.value.add(_mark);
    });
    _markers.refresh();
  }

  Future<Marker> _generateMarker(MyMapTyes type, LocationModel location) async {
    late BitmapDescriptor _icon;
    if (type == MyMapTyes.regular) {
      _icon = BitmapDescriptor.defaultMarker;
    } else {
      _icon = await _markerCusomImage(location.placePicture);
    }
    Marker marker = Marker(
        markerId: MarkerId(location.hashCode.toString()),
        position: LatLng((location.lat ?? 0), location.lng ?? 0),
        icon: (_icon),
        onTap: () {
          Get.dialog(Dialog(
            child: LocationDescriptionPage(location: location),
          ));
        });
    return marker;
  }

  static Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes("./assets/images/$iconPath.png");
  }

  Future<BitmapDescriptor> _markerCusomImage(String? placePicture) async {
    late Uint8List _imageByte;
    if (placePicture == null) {
      _imageByte = await _getImageFromAsset('dash');
    } else {
      final File markerImageFile = await DefaultCacheManager().getSingleFile(placePicture);
      _imageByte = await markerImageFile.readAsBytes();
    }
    final int targetWidth = 80;

    final Codec markerImageCodec = await instantiateImageCodec(
      _imageByte,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
  }

  void setInitialPosition(double lat, double lng) {
    _initialPositionMap.value = LatLng(lat, lng);
  }
}
