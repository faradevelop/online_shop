import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.setPosition});

  final Function(LatLng point) setPosition;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();

  List<Marker> markers = [];

  late LatLng _currentPosition;
  late double _zoom;
  bool _loadingPoint = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    mapController.move(LatLng(position.latitude, position.longitude), _zoom);
    _currentPosition = LatLng(position.latitude, position.longitude);
    markers.add(Marker(
      point: LatLng(position.latitude, position.longitude),
      child: const Icon(
        CupertinoIcons.location_solid,
        color: Color(0xFFED723F),
        size: 45,
      ),
    ));
    return position;
  }

  @override
  void initState() {
    _zoom = 15;
    _determinePosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                interactionOptions: const InteractionOptions(),
                initialCenter: const LatLng(35.69971, 51.33719),
                initialZoom: _zoom,
                onTap: (tapPosition, point) {
                  markers.clear();
                  markers.add(Marker(
                    point: point,
                    child: Icon(
                      CupertinoIcons.location_solid,
                      color: Theme.of(context).primaryColor,
                      size: 45,
                    ),
                  ));
                  _currentPosition = point;
                  setState(() {});
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: markers,
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: AppbarWidget(
                title: 'انتخاب آدرس از روی نقشه',
                backButton: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              right: 18,
              top: 90,
              child: GestureDetector(
                onTap: () async {
                  markers.clear();

                  setState(() {
                    _loadingPoint = true;
                  });
                  await _determinePosition();
                  /* mapController.move(
                      _currentPosition,
                      15);
                  markers.add(Marker(
                    point: LatLng(
                        _currentPosition.latitude, _currentPosition.longitude),
                    child: Icon(
                      CupertinoIcons.location_solid,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      size: 45,
                    ),
                  ));*/
                  setState(() {
                    _loadingPoint = false;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _loadingPoint
                        ? const CupertinoActivityIndicator()
                        : const Icon(
                            CupertinoIcons.location_fill,
                            size: 22,
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ButtonWidget(
                    text: "ثبت",
                    onPressed: () {
                      widget.setPosition(_currentPosition);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: SnackBarContentWidget(
                              msg: "لوکیشن ثبت شد.",
                              icn: CupertinoIcons.check_mark_circled)));
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
