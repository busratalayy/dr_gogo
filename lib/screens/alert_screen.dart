import 'package:flutter/material.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {
    final alerts = [
      AlertItem(
        title: "High Pulse Detected",
        message: "Heart rate reached 185 BPM.",
        time: "2 min ago",
        icon: Icons.favorite,
        color: Colors.red,
      ),
      AlertItem(
        title: "Sudden Movement",
        message: "Possible impact or unusual movement detected.",
        time: "12 min ago",
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
      ),
      AlertItem(
        title: "Device Disconnected",
        message: "ESP32 collar connection was lost.",
        time: "25 min ago",
        icon: Icons.bluetooth_disabled,
        color: Colors.blueGrey,
      ),
      AlertItem(
        title: "Location Signal Weak",
        message: "GPS signal quality is currently low.",
        time: "40 min ago",
        icon: Icons.location_off,
        color: Colors.green,
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Alerts",
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
      bottomNavigationBar:
      const BottomNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Health Alerts 🔔",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Warnings generated from pulse, motion, GPS and device status.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
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
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: alert.color.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            alert.icon,
                            color: alert.color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                alert.message,
                                style: const TextStyle(
                                  color: subtitleColor,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                alert.time,
                                style: TextStyle(
                                  color: alert.color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class AlertItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;

  AlertItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
  });
}