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
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  PolylineAnnotationManager? polylineAnnotationManager;
  int styleIndex = 1;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;

    // create annotation manager to add markers/annotations
    mapboxMap.annotations.createPointAnnotationManager().then((value) {
      pointAnnotationManager = value;
      createOneMarker();
    });

    // create polylineAnnotationManager to add a line
    mapboxMap.annotations.createPolylineAnnotationManager().then((value) async {
      polylineAnnotationManager = value;
      await createOnePolyLine();

      await createHighlightedLine();

      await createDirectionalArrow();
    });
  }

  Future<void> createOneMarker() async {
    // load the marker icon
    final bytes = await rootBundle.load('assets/marker_icon.png');
    final list = bytes.buffer.asUint8List();

    // create annotation manager and add the point
    final point = PointAnnotationOptions(
      geometry: Point(coordinates: Position(51.5286911, 25.3270487)).toJson(),
      image: list,
      iconSize: 0.25,
    );
    await pointAnnotationManager?.create(point);
  }

  Future<PolylineAnnotation?> createOnePolyLine() async {
    final line = await polylineAnnotationManager?.create(
      PolylineAnnotationOptions(
        geometry: LineString(
          coordinates: [
            Position(51.5290019497385, 25.32747158443125),
            Position(51.52957057805003, 25.32747158443125),
            Position(51.52957057805003, 25.33039051297932),
            Position(51.5315744467014, 25.330437034284344),
            Position(51.532871455187546, 25.33135813001911),
            Position(51.535758843131106, 25.33135813001911),
          ],
        ).toJson(),
        lineColor: Colors.red.value,
        lineWidth: 8,
        lineBorderColor: Colors.black.value,
        lineBorderWidth: 3,
        lineJoin: LineJoin.ROUND,
      ),
    );

    return line;
  }

  Future<void> createHighlightedLine() async {
    final highlighedLine = await polylineAnnotationManager?.create(
      PolylineAnnotationOptions(
        geometry: LineString(
          coordinates: [
            Position(51.52957057805003, 25.33039051297932),
            Position(51.5315744467014, 25.330437034284344),
            Position(51.532871455187546, 25.33135813001911),
          ],
        ).toJson(),
        lineColor: Colors.blue.value,
        lineWidth: 10,
        lineBorderColor: Colors.black.value,
        lineBorderWidth: 3,
        lineJoin: LineJoin.ROUND,
      ),
    );

    if (highlighedLine != null) {
      await polylineAnnotationManager?.update(highlighedLine);
    }
  }

  Future<void> createDirectionalArrow() async {
    if (pointAnnotationManager != null) {
      final bytes = await rootBundle.load('assets/arrow_icon.png');
      final list = bytes.buffer.asUint8List();

      await pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry:
              Point(coordinates: Position(51.5315744467014, 25.330437034284344))
                  .toJson(),
          image: list,
          iconSize: 0.25,
          iconRotate: 45,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MapWidget(
        onMapCreated: _onMapCreated,
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(51.5286911, 25.3270487)).toJson(),
          zoom: 15,
          pitch: 0,
        ),
      ),
    );
  }
}
