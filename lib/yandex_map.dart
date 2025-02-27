import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPage extends StatefulWidget {
  const YandexMapPage({super.key});

  @override
  State<YandexMapPage> createState() => _YandexMapPageState();
}

class _YandexMapPageState extends State<YandexMapPage> {
  late final YandexMapController _yandexMapController;

  final double _currentZoom = 10;

  final _animConfig = const MapAnimation(
    type: MapAnimationType.smooth,
    duration: 0.1,
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (controller) async {
          _yandexMapController = controller;

          final currentPosition = await checkPermission();
          log('currentPosition: $currentPosition');
          await moveCameraToPosition(
            Point(
              latitude: currentPosition.latitude,
              longitude: currentPosition.longitude,
            ),
          );
        },
        onCameraPositionChanged: (pos, reason, ended) async {
          log('pos: ${pos.target}, reason: $reason, ended: $ended');
          // await moveCameraToPosition(pos.target);
        },
      ),
    );
  }

  Future<void> moveCameraToPosition(Point pointTarget) async {
    await _yandexMapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pointTarget, zoom: _currentZoom),
      ),
      animation: _animConfig,
    );
  }
}
