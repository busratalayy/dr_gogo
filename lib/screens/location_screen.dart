import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});


  static const LatLng petLocation =
  LatLng(41.0082, 28.9784);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Location",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),
      bottomNavigationBar:
      const BottomNavBar(currentIndex: 0),
      body: Stack(

        children: [

          // Google Map
          GoogleMap(

            initialCameraPosition:
            const CameraPosition(

              target: petLocation,

              zoom: 15,
            ),

            markers: {

              Marker(

                markerId:
                const MarkerId(
                    "pet_location"),

                position: petLocation,

                infoWindow:
                const InfoWindow(

                  title: "Dr. Gogo",

                  snippet:
                  "Current Pet Location",
                ),
              ),
            },
          ),

          // Top Info Card
          Positioned(

            top: 18,
            left: 18,
            right: 18,

            child: Container(

              padding:
              const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                    24),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.08),

                    blurRadius: 16,

                    offset:
                    const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Container(

                    width: 58,
                    height: 58,

                    decoration:
                    BoxDecoration(

                      color: Colors.green
                          .withOpacity(0.12),

                      borderRadius:
                      BorderRadius
                          .circular(
                          18),
                    ),

                    child: const Icon(
                      Icons.pets,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        const Text(
                          "Pet Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 4),

                        Text(
                          "Lat: ${petLocation.latitude}",
                          style:
                          const TextStyle(
                            color:
                            Colors.grey,
                          ),
                        ),

                        Text(
                          "Lng: ${petLocation.longitude}",
                          style:
                          const TextStyle(
                            color:
                            Colors.grey,
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
}