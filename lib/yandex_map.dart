import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class YandexMapPage extends StatefulWidget {
  const YandexMapPage({super.key});

  @override
  State<YandexMapPage> createState() => _YandexMapPageState();
}

class _YandexMapPageState extends State<YandexMapPage> {
  // late final YandexMapController _yandexMapController;

  final double _currentZoom = 10;

  // final _animConfig = const MapAnimation(
  //   type: MapAnimationType.smooth,
  //   duration: 0.1,
  // );

  Future<Position> checkPermission() async {
    late bool serviceEnabled;
    late LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  MapWindow? mapWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (mapWindow) async {

          mapWindow = mapWindow;

          // final currentPosition = await checkPermission();
          // log('currentPosition: $currentPosition');
          // await moveCameraToPosition(
          //   Point(
          //     latitude: currentPosition.latitude,
          //     longitude: currentPosition.longitude,
          //   ),
          // );
        },
      ),
    );
  }

  Future<void> moveCameraToPosition(Point pointTarget) async {

    // await _yandexMapController.moveCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(target: pointTarget, zoom: _currentZoom),
    //   ),
    //   animation: _animConfig,
    // );
  }
}
