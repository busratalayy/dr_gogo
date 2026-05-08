import 'package:dr_gogo/screens/health_vaccine_screen.dart';
import 'package:dr_gogo/screens/rest_monitoring_screen.dart';
import 'package:flutter/material.dart';
import 'package:dr_gogo/screens/pet_profile_screen.dart';
import 'package:dr_gogo/screens/activity_screen.dart';
import  'package:dr_gogo/screens/food_water_screen.dart';


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
      DashboardItem("Activity", Icons.directions_run, Colors.blue),
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
      body: Padding(
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
            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
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
                        }
                        else if (item.title == "Activity") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const ActivityScreen(),
                            ),
                          );
                        }
                        else if (item.title == "Food & Water") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FoodWaterScreen(),
                            ),
                          );
                        }
                        else if (item.title == "Health & Vaccine") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealthVaccineScreen(),
                            ),
                          );
                        }
                        else if (item.title == "Rest Monitor") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RestMonitoringScreen(),
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
            ),
          ],
        ),
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