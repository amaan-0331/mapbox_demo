import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _onMapCreated(MapboxMap mapboxMap) {
    // create annotation manager to add markers/annotations
    mapboxMap.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      // load the marker icon
      final bytes = await rootBundle.load('assets/marker_icon.png');
      final list = bytes.buffer.asUint8List();

      // create annotation manager and add the point
      final point = PointAnnotationOptions(
        geometry: Point(coordinates: Position(51.5286911, 25.3270487)).toJson(),
        image: list,
        iconSize: 0.25,
      );
      await pointAnnotationManager.create(point);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MapWidget(
        onMapCreated: _onMapCreated,
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(51.5286911, 25.3270487)).toJson(),
          zoom: 15,
          pitch: 50,
        ),
      ),
    );
  }
}
