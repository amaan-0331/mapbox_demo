import 'package:flutter/material.dart';
import 'package:mapbox_demo/src/app.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const accessToken = String.fromEnvironment('MAPBOX_PUBLIC_ACCESS_TOKEN');
  debugPrint(accessToken);
  MapboxOptions.setAccessToken(accessToken);

  runApp(const MainApp());
}
