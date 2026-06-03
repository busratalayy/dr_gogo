import 'package:flutter/material.dart';
import 'package:dr_gogo/screens/pet_profile_screen.dart';
import 'package:dr_gogo/screens/activity_screen.dart';
import 'package:dr_gogo/screens/food_water_screen.dart';
import 'package:dr_gogo/screens/location_screen.dart';
import 'package:dr_gogo/screens/health_vaccine_screen.dart';
import 'package:dr_gogo/screens/rest_monitoring_screen.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem("Pet Profile", Icons.pets, Colors.purple),
      DashboardItem("Activity", Icons.pets, Colors.blue),
      DashboardItem("Food & Water", Icons.restaurant, Colors.orange),
      DashboardItem("Location", Icons.location_on, Colors.green),
      DashboardItem("Rest Monitor", Icons.nightlight_round, Colors.indigo),
      DashboardItem("Health & Vaccine", Icons.health_and_safety, Colors.red),
    ];

    return Scaffold(

      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textColor,
        title: const Text(
          "Dr. Gogo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      bottomNavigationBar:
      const BottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Luna 🐾",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Monitor your pet’s health and activity",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            buildPulseCard(),

            const SizedBox(height: 22),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  color: cardColor,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      if (item.title == "Pet Profile") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PetProfileScreen(),
                          ),
                        );
                      } else if (item.title == "Activity") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivityScreen(),
                          ),
                        );
                      } else if (item.title == "Food & Water") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FoodWaterScreen(),
                          ),
                        );
                      } else if (item.title == "Location") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationScreen(),
                          ),
                        );
                      } else if (item.title == "Rest Monitor") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RestMonitoringScreen(),
                          ),
                        );
                      } else if (item.title == "Health & Vaccine") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HealthVaccineScreen(),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 31,
                            backgroundColor: item.color.withOpacity(0.14),
                            child: Icon(
                              item.icon,
                              color: item.color,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPulseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.pink.shade100,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.favorite,
              color: Colors.red.shade400,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Average Pulse",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "118",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        "BPM",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10,
                ),
                SizedBox(width: 6),
                Text(
                  "Normal",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;

  DashboardItem(this.title, this.icon, this.color);
}