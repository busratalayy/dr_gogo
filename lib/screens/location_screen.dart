import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  final DatabaseReference gpsRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://dr-gogo-a2975-default-rtdb.europe-west1.firebasedatabase.app",
  ).ref("gps");

  GoogleMapController? mapController;

  LatLng petLocation = const LatLng(41.0082, 28.9784);
  String lastUpdate = "No data";
  bool gpsDataReceived = false;

  @override
  void initState() {
    super.initState();
    listenGpsData();
  }

  void listenGpsData() {
    gpsRef.onValue.listen((event) {
      final data = event.snapshot.value;

      print("Firebase GPS data: $data");

      if (data == null) {
        return;
      }

      try {
        final map = Map<dynamic, dynamic>.from(data as Map);

        final latitude = double.tryParse(map["latitude"].toString());
        final longitude = double.tryParse(map["longitude"].toString());

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        if (latitude == null || longitude == null) {
          return;
        }

        final newLocation = LatLng(latitude, longitude);

        setState(() {
          petLocation = newLocation;
          gpsDataReceived = true;
          lastUpdate = DateTime.now().toString().substring(0, 19);
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 17),
        );
      } catch (e) {
        print("GPS data parse error: $e");
      }
    });
  }

  void getTodayMovement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Movement calculation will be added later."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Location",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: petLocation,
                zoom: 16,
              ),
              onMapCreated: (controller) {
                mapController = controller;

                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(petLocation, 16),
                );
              },
              markers: {
                Marker(
                  markerId: const MarkerId("pet_location"),
                  position: petLocation,
                  infoWindow: const InfoWindow(
                    title: "Dr. Gogo",
                    snippet: "Live Pet Location",
                  ),
                ),
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  buildInfoCard(
                    icon: Icons.location_on,
                    iconColor: Colors.green,
                    title: "Current Location",
                    value: gpsDataReceived
                        ? "Live GPS data received"
                        : "Waiting for GPS data...",
                    subtitle: "Last update: $lastUpdate",
                  ),
                  const SizedBox(height: 14),
                  buildInfoCard(
                    icon: Icons.my_location,
                    iconColor: Colors.blue,
                    title: "Last Known Coordinates",
                    value:
                    "Lat: ${petLocation.latitude.toStringAsFixed(6)}",
                    subtitle:
                    "Lng: ${petLocation.longitude.toStringAsFixed(6)}",
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: buildCardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.directions_walk,
                                color: Colors.orange,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's Movement",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "0.0 km",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => getTodayMovement(context),
                            icon: const Icon(Icons.route),
                            label: const Text(
                              "Get Today's Movement",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: buildCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildCardDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}